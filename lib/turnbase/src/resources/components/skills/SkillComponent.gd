extends Resource
class_name SkillComponent

# @export var target: SkillBase.Target

@export var condition: SkillComponentCondition
@export var mechanic: SkillComponentMechanic

func run_component(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if _target == null or _source == null or _skill == null:
		return false
  
	var get_target = _target
	# match target:
	# 	SkillBase.Target.Foe:
	# 		get_target = _target
	# 	SkillBase.Target.Self:
	# 		get_target = _source
  
	if check_condition(get_target, _source, _skill):
		apply_mechanic(get_target, _source, _skill)
	else:
		print("[!] Skill Condition is false")
	return true

func check_condition(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if condition == null:
		return true
	if condition is SkillComponentCondition:
		return true
	return false

func apply_mechanic(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	if mechanic == null:
		return true
	if mechanic is SkillComponentMechanicDamage:
		var mechanic_damage: SkillComponentMechanicDamage = mechanic
		return mechanic_damage.apply(_target, _source, _skill)
	if mechanic is SkillComponentMechanicAttribute:
		var mechanic_attribute: SkillComponentMechanicAttribute = mechanic
		return mechanic_attribute.apply(_target, _source, _skill)
	if mechanic is SkillComponentMechanic:
		return true
	return false
