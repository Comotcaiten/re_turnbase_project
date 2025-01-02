extends Node
class_name UnitModel

#--------------------------------------------------------------------------------
# Import
@export var character_base: CharacterBase
@export var level: int

@export var is_player: bool

@export var mesh: MeshInstance3D

@export var color_target: Color
@export var color_normal: Color

@export var icon_target: Sprite3D

@export var hp_bar: HPBar
#--------------------------------------------------------------------------------
var team: String = "None"
var is_fainted: bool = false

var element: CharacterBase.Element

var stats_base: Dictionary:
	get:
		return character_base.get_stats()

var stats_modified: Dictionary = CharacterBase.get_stats_default()

var skills: Array[SkillModel]
#--------------------------------------------------------------------------------
# Chỉ số
var health: int
var max_health: int:
	get:
		return get_stat(CharacterBase.StatType.MaxHealth)

var attack_physical: int:
	get:
		return get_stat(CharacterBase.StatType.AttackPhysical)
var attack_magic: int:
	get:
		return get_stat(CharacterBase.StatType.AttackMagic)

var defense_physical: int:
	get:
		return get_stat(CharacterBase.StatType.DefensePhysical)
var defense_magic: int:
	get:
		return get_stat(CharacterBase.StatType.DefenseMagic)

var speed: int:
	get:
		return get_stat(CharacterBase.StatType.Speed)
#--------------------------------------------------------------------------------
# Hàm khởi tạo
func initialize(_character_base: CharacterBase = null, _level: int = 0) -> bool:
	if _character_base == null or _level <= 0:
		return false
	character_base = _character_base
	level = _level
	start()
	return true

func start():
	element = character_base.element
	health = max_health
	
	for skill in character_base.skills:
		if skill == null:
			continue
		skills.append(SkillModel.new(skill))
	pass

func _ready():
	mesh.material_override = StandardMaterial3D.new()
	mesh.material_override.albedo_color = color_normal
	start()
	show()
	icon_target.visible = false

	hp_bar.update_hp()
	pass

#--------------------------------------------------------------------------------
# Các hàm lấy thông tin
func get_stat(_stat: CharacterBase.StatType):
	var amount_base = stats_base[_stat] * 1.0
	var amount_modified = stats_modified[_stat] * 1.0

	var amount_stat: float = (amount_base + ((amount_base * amount_modified) / 100.0)) * (level * 1.0)

	return int(amount_stat)

func get_defense(_type_attack: DamageModel.TypeAttack) -> int:
	match _type_attack:
		DamageModel.TypeAttack.Physical:
			return defense_physical
		DamageModel.TypeAttack.Magic:
			return defense_magic
		_:
			return 1

func get_skill(_index: int) -> SkillModel:
	if _index >= skills.size():
		return null
	return skills[_index]

func get_random_skill() -> SkillModel:
	if skills.size() <= 0:
		return null
	return skills[randi() % skills.size()]

#--------------------------------------------------------------------------------
# Các hàm cập nhật thông tin
func set_health(_value: int):
	health = clamp(_value, 0, max_health)
	if health <= 0:
		is_fainted = true

#--------------------------------------------------------------------------------
# Các hàm xử lý sự kiện
func take_damage(_damage_model: DamageModel = null, _source: UnitModel = null):
	if _damage_model == null or _source == null:
		return false
		
	_damage_model.set_target(self)
	_damage_model.set_source(_source)

	# Lấy giá trị phòng thủ
	var defense: int = get_defense(_damage_model.type_attack)
	if _damage_model.true_damage:
		defense = 1 # Bỏ qua phòng thủ nếu là sát thương thật

	# Tính toán sát thương
	var damage: int = int((_damage_model.calculate_damage() * 1.0) / max(1, defense * 1.0))
	print("[Get Damage]: ", name, " receives ", damage, " damage from ", _source.name)

	# Giảm máu
	set_health(health - damage)

	# Kích hoạt tín hiệu
	signal_get_damage(_damage_model, _source)

	# Cập nhật thanh máu
	hp_bar.update_hp()
	return true

func hide():
	self.visible = false

func show():
	self.visible = true

func change_mesh_target() -> bool:
	if mesh == null:
		return false
	mesh.material_override.albedo_color = color_target

	icon_target.visible = true
	return true

func change_mesh_normal() -> bool:
	if mesh == null:
		return false
	mesh.material_override.albedo_color = color_normal

	icon_target.visible = false
	return true
#--------------------------------------------------------------------------------
# Signal
func signal_get_damage(_damage_detail: DamageModel, _source: UnitModel):
	print("> signal_get_damage: ", _damage_detail)
	print("> source: ", _source)
	print("> target: ", self)
	print(self, " HP: ", health, "/", max_health)
	pass

#--------------------------------------------------------------------------------
# Debug - Utils
# In ra thông tin của Unit
func print_stat():
	print("Unit ID: ", character_base)
	print("Name: ", character_base.name)
	print("Level: ", level)
	print("Is Player: ", is_player)
	print("Element: ", element)

	print("Health: ", health, "/", max_health)
	print("Attack (Physical): ", attack_physical)
	print("Attack (Magic): ", attack_magic)
	print("Defense (Physical): ", defense_physical)
	print("Defense (Magic): ", defense_magic)
	print("Speed: ", speed)

	# In ra các kỹ năng của Unit
	print("Skills:")
	for skill in skills:
		print("  - ", skill)
