extends Node
class_name UnitModel

@export var character_base: CharacterBase
@export var level: int

@export var is_player: bool

var id_groups: String
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

func initialize(_character_base: CharacterBase, _level: int):
  character_base = _character_base
  level = _level

func _ready():
  health = character_base.max_health

  element = character_base.element
  pass

func get_stat(_stat: CharacterBase.StatType):
  var amount_base = stats_base[_stat] * 1.0
  var amount_modified = stats_modified[_stat] * 1.0

  var amount_stat = amount_base + ((amount_base * amount_modified) / 100.0)

  return int(amount_stat)
