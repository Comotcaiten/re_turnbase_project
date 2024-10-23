extends Resource
class_name SkillComponent


@export var condition: SkillComponentCondition
@export var mechanic: SkillComponentMechanic

func run_component(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if _target == null or _source == null or _skill == null:
		return false
  
	var get_target = _target
	match _skill.base.target:
		SkillBase.Target.Foe:
			get_target = _target
		SkillBase.Target.Self:
			get_target = _source
	
	# if _source == _target:
	# 	print("[>] <> True")
	# else:
	# 	print("[>] <> False")
  
	if check_condition(get_target, _source, _skill) == true:
		apply_mechanic(get_target, _source, _skill)
		return true
	else:
		return false

func check_condition(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if condition == null:
		return true

	if condition is SkillComponentConditionAttribute:
		var condition_attr: SkillComponentConditionAttribute = condition
		return condition_attr.is_condition_met(_target, _source, _skill)

	if condition is SkillComponentCondition:
		return true
	return false

func apply_mechanic(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if mechanic == null:
		return true

	if mechanic is SkillComponentMechanicDamage:
		var mechanic_damage: SkillComponentMechanicDamage = mechanic
		print("[Damage]")
		return mechanic_damage.apply(_target, _source, _skill)
	if mechanic is SkillComponentMechanicAttribute:
		var mechanic_attribute: SkillComponentMechanicAttribute = mechanic
		print("[Attribute]")
		return mechanic_attribute.apply(_target, _source, _skill)

	if mechanic is SkillComponentMechanicReven:
		var reven: SkillComponentMechanicReven = mechanic
		return reven.apply(_target, _source, _skill)

	if mechanic is SkillComponentMechanic:
		return true
	return false
