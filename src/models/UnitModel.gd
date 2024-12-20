extends Node
class_name UnitModel

@export var character_base: CharacterBase
@export var level: int

@export var is_player: bool

var id_groups_in_battle: String
var is_fainted: bool = false

var element: CharacterBase.Element:
  get:
    return character_base.element

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
  set_skills()

func _ready():
  health = character_base.max_health
  set_skills()
  pass

func get_stat(_stat: CharacterBase.StatType):
  var amount_base = stats_base[_stat] * 1.0
  var amount_modified = stats_modified[_stat] * 1.0

  var amount_stat = amount_base + ((amount_base * amount_modified) / 100.0)

  return int(amount_stat)

func get_defense(_type_attack: DamageDetailModel.TypeAttack):
  match _type_attack:
    DamageDetailModel.TypeAttack.Physical:
      return defense_physical
    DamageDetailModel.TypeAttack.Magic:
      return defense_physical

func get_damage(_damage_detail: DamageDetailModel, _source: UnitModel):
  # Step 1
  var defense: int = get_defense(_damage_detail.type_attack)
  var damage_amount = _damage_detail.damage_amount

  if _damage_detail.true_damage:
    defense = 0
  damage_amount = int((damage_amount * 1.0) / max(1.0, defense * 1.0))
  # Step 2
  set_health(damage_amount, _source)
  # Step 3
  signal_get_damage(_damage_detail, _source)
  pass

func get_skill(_index: int) -> SkillModel:
  if _index >= skills.size():
    return null
  return skills[_index]

func set_stat_modified(_stat: CharacterBase.StatType, _amount: int):
  # Step 1
  stats_modified[_stat] = _amount
  # Step 2
  signal_set_stat_modified(_stat, _amount)
  pass

func set_health(_amount_add: int, _source: UnitModel):
  # Step 1
  health += _amount_add
  # Step 2
  signal_set_health(_amount_add, _source)
  pass

func set_skills():
  for skill in character_base.skills:
    if skill == null:
      continue
    skills.append(SkillModel.new(skill))
  return

func signal_get_damage(_damage_detail: DamageDetailModel, _source: UnitModel):
  print("> signal_get_damage: ", _damage_detail)
  pass

func signal_set_stat_modified(_stat: CharacterBase.StatType, _amount: int):
  print("> signal_set_stat_modified: ", CharacterBase.StatType.find_key(_stat), ": ", _amount, " | ", stats_modified[_stat])
  pass

func signal_set_health(_amount: int, _source: UnitModel):
  print("> signal_set_health: ", _amount)
  pass