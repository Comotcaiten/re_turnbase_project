class_name SkillModel

var skill_base: SkillBase

var element: CharacterBase.Element
var target_type: SkillBase.TargetType:
  get:
    return skill_base.target_type

var target_mode: SkillBase.TargetMode:
  get:
    return skill_base.target_mode

func _init(_skill_base: SkillBase):
  skill_base = _skill_base
  element = _skill_base.element
  pass