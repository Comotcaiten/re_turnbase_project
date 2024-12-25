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

func _init(_skill_base: SkillBase):
  skill_base = _skill_base
  element = _skill_base.element
  pass

func run(_targets: Array[UnitModel], _source: UnitModel, _battle_system: BattleSystemController) -> bool:
  match skill_base.break_point:
    SkillBase.BreakPointMode.None:
        for component in skill_base.components:
          component.run(_targets, _source, self, _battle_system)
        return true
    SkillBase.BreakPointMode.True:
        for component in skill_base.components:
          if component.run(_targets, _source, self, _battle_system) == true:
            return true
        return false
    SkillBase.BreakPointMode.False:
        for component in skill_base.components:
          if component.run(_targets, _source, self, _battle_system) == false:
            return true
        return false
  return true