### Autoload: nhân vật đang sở hữu, đội hình và lưu game
extends Node

const CATALOG_DIR := "res://asset/character_base/"
const MAX_TEAM_SIZE := 4
const START_LEVEL := 10

var save_path: String = "user://save.json"

var owned: Array[OwnedUnit] = []
var team: Array[OwnedUnit] = []

# Đội được đưa vào trận. Rỗng thì trận dùng đội đặt sẵn trong scene
var battle_team: Array[UnitNode] = []

func _ready():
	load_game()

# Mọi UnitBase có id trong CATALOG_DIR
func load_catalog() -> Dictionary:
	var catalog := {}
	for file in DirAccess.get_files_at(CATALOG_DIR):
		# Bản export đổi .tres thành .tres.remap nhưng vẫn load bằng đường dẫn .tres
		var path: String = CATALOG_DIR + file.trim_suffix(".remap")
		if not path.ends_with(".tres"):
			continue
		var unit_base = load(path)
		if unit_base is UnitBase and unit_base.id != "":
			catalog[unit_base.id] = unit_base
	return catalog

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
	if unit not in team:
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
		units.append({"id": unit.base.id, "level": unit.level})
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
			owned.append(OwnedUnit.new(unit_base, int(entry.get("level", 1))))
	for id in data.get("team", []):
		var unit := find_owned(id)
		if unit != null and unit not in team and team.size() < MAX_TEAM_SIZE:
			team.append(unit)
