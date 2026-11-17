### Autoload: nhân vật đang sở hữu, đội hình và lưu game
extends Node

const MAX_TEAM_SIZE := 4
const START_LEVEL := 10

var catalog_dir: String = "res://asset/character/"
var item_dir: String = "res://asset/item/"
var item_catalog: Array[ItemBase] = []
var save_path: String = "user://save.json"

var owned: Array[OwnedUnit] = []
var team: Array[OwnedUnit] = []

# Đội được đưa vào trận. Rỗng thì trận dùng đội đặt sẵn trong scene
var battle_team: Array[UnitNode] = []

func _ready():
	load_item_catalog()
	load_game()
	ensure_team()

# Luôn có đội để nút Vào đấu dùng được ngay
func ensure_team():
	if not team.is_empty():
		return
	for unit in owned:
		if team.size() >= MAX_TEAM_SIZE:
			break
		team.append(unit)

# Mọi UnitBase có id trong catalog_dir
func load_catalog() -> Dictionary:
	var catalog := {}
	for unit_base in load_resources(catalog_dir):
		if unit_base is UnitBase and unit_base.id != "":
			catalog[unit_base.id] = unit_base
	return catalog

func load_item_catalog():
	item_catalog.clear()
	for item in load_resources(item_dir):
		if item is ItemBase and item.id != "":
			item_catalog.append(item)
	item_catalog.sort_custom(func(a, b): return a.cost < b.cost)

func load_resources(dir: String) -> Array:
	var resources := []
	for file in DirAccess.get_files_at(dir):
		# Bản export đổi .tres thành .tres.remap nhưng vẫn load bằng đường dẫn .tres
		var path: String = dir + file.trim_suffix(".remap")
		if path.ends_with(".tres"):
			resources.append(load(path))
	return resources

func find_item(id: String) -> ItemBase:
	for item in item_catalog:
		if item.id == id:
			return item
	return null

func equip_item(unit: OwnedUnit, item: ItemBase) -> bool:
	if not unit.equip(item):
		return false
	save_game()
	return true

func unequip_item_at(unit: OwnedUnit, index: int) -> bool:
	if not unit.unequip_at(index):
		return false
	save_game()
	return true

func new_game():
	owned.clear()
	team.clear()
	for unit_base in load_catalog().values():
		owned.append(OwnedUnit.new(unit_base, START_LEVEL))

func find_owned(id: String) -> OwnedUnit:
	for unit in owned:
		if unit.base.id == id:
			return unit
	return null

func add_unit(unit_base: UnitBase) -> bool:
	if unit_base == null or find_owned(unit_base.id) != null:
		return false
	owned.append(OwnedUnit.new(unit_base, START_LEVEL))
	save_game()
	return true

func level_up(unit: OwnedUnit) -> bool:
	if not unit.level_up():
		return false
	save_game()
	return true

func is_in_team(unit: OwnedUnit) -> bool:
	return unit in team

func add_to_team(unit: OwnedUnit) -> bool:
	if unit in team or team.size() >= MAX_TEAM_SIZE:
		return false
	team.append(unit)
	save_game()
	return true

func remove_from_team(unit: OwnedUnit) -> bool:
	if unit not in team or team.size() <= 1:
		return false
	team.erase(unit)
	save_game()
	return true

func prepare_battle():
	battle_team.clear()
	for unit in team:
		battle_team.append(unit.to_unit_node())

func finish_battle():
	battle_team.clear()

func save_game() -> bool:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_warning("PlayerCollection >> Cannot write save: %s" % save_path)
		return false
	var units := []
	for unit in owned:
		units.append({"id": unit.base.id, "level": unit.level, "items": unit.items.map(func(item): return item.id)})
	var team_ids := []
	for unit in team:
		team_ids.append(unit.base.id)
	file.store_string(JSON.stringify({"version": 1, "units": units, "team": team_ids}, "\t"))
	return true

func load_game():
	if not FileAccess.file_exists(save_path):
		new_game()
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if not data is Dictionary:
		push_warning("PlayerCollection >> Invalid save, starting a new game: %s" % save_path)
		new_game()
		return

	owned.clear()
	team.clear()
	var catalog := load_catalog()
	for entry in data.get("units", []):
		var unit_base = catalog.get(entry.get("id", ""))
		if unit_base != null:
			var unit := OwnedUnit.new(unit_base, int(entry.get("level", 1)))
			for item_id in entry.get("items", []):
				unit.equip(find_item(item_id)) # Item không còn tồn tại hoặc vượt giới hạn thì bỏ qua
			owned.append(unit)
	if owned.is_empty():
		new_game()
		return
	for id in data.get("team", []):
		var unit := find_owned(id)
		if unit != null and unit not in team and team.size() < MAX_TEAM_SIZE:
			team.append(unit)
