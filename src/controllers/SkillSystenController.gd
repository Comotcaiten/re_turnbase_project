class_name SkillSystenController

var battle_system_controller: BattleSystemController

var current_target: int = 0

func _init(_system: BattleSystemController):
  battle_system_controller = _system
  return

func perform_select_target(_skill: SkillModel):

  match _skill.target_type:
    SkillBase.TargetType.SELF:
      pass
    SkillBase.TargetType.ENEMY:
      pass
    SkillBase.TargetType.ALLY:
      pass
    SkillBase.TargetType.ANY:
      pass
  pass