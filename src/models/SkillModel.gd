class_name SkillModel

var skill_base: SkillBase

var element: CharacterBase.Element
var target_type: SkillBase.TargetType:
  get:
    return skill_base.target_type

var target_mode: SkillBase.TargetMode:
  get:
    return skill_base.target_mode

var target_fainted: SkillBase.TargetFainted:
  get:
    return skill_base.target_fainted

var components: Array[SkillComponent]:
  get:
    return skill_base.components

func _init(_skill_base: SkillBase):
  skill_base = _skill_base
  element = _skill_base.element
  pass

func run(targets: Array[UnitModel] = [], source: UnitModel = null, battle_system: BattleSystemController = null) -> bool:
  if targets.size() == 0 or source == null or battle_system == null:
    return false
  for component in components:
    if not component.excute(targets, source, self, battle_system):
      return false
  return true