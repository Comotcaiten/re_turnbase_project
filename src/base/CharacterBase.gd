extends Resource
class_name CharacterBase

enum StatType {MaxHealth, AttackPhysical, AttackMagic, DefensePhysical, DefenseMagic, Speed}
enum Element {Physical, Fire, Water}

@export var name: String

@export var element: Element = Element.Physical

@export var max_health: int = 100

@export_group("Attack")
@export var attack_physical: int = 10
@export var attack_magic: int = 10

@export_group("Defense")
@export var defense_physical: int = 5
@export var defense_magic: int = 5

@export_group("Speed")
@export var speed: int = 10

@export_group("Skill")
var max_skills: int = 4
@export var skills: Array[SkillBase] = []

func get_stats():
	return {
		StatType.MaxHealth: max(0, max_health),

		StatType.AttackPhysical: max(0, attack_physical),
		StatType.AttackMagic: max(0, attack_magic),

		StatType.DefensePhysical: max(0, defense_physical),
		StatType.DefenseMagic: max(0, defense_magic),

		StatType.Speed: max(0, speed),
	}

static func get_stats_default():
	return {
		StatType.MaxHealth: 0,

		StatType.AttackPhysical: 0,
		StatType.AttackMagic: 0,

		StatType.DefensePhysical: 0,
		StatType.DefenseMagic: 0,
		
		StatType.Speed: 0,
	}

func _init(
	_name: String = "Unnamed Character",
	_element: Element = Element.Physical,
	_max_health: int = 100,
	_attack_physical: int = 10,
	_attack_magic: int = 10,
	_defense_physical: int = 5,
	_defense_magic: int = 5,
	_speed: int = 10,
):
	name = _name
	element = _element
	max_health = _max_health
	attack_physical = _attack_physical
	attack_magic = _attack_magic
	defense_physical = _defense_physical
	defense_magic = _defense_magic
	speed = _speed