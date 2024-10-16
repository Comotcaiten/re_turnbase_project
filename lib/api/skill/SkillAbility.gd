extends Resource
class_name SkillAbility

@export var target: SkillBase.Target

@export var condition: SkillCondition

@export var mechanic: SkillMechanic

func CanApply(_source: Character, _target: Character, _skill: Skill) -> bool:
	var _get_target: Character
	match target:
		SkillBase.Target.Foe:
			print("[>] Target: Foe")
			_get_target = _target
		SkillBase.Target.Self:
			print("[>] Target: Self")
			_get_target = _source

	if CanRun(_source, _get_target, _skill):
		print("[>] Can run skill mechanic")
		var mechanic_run: bool = RunMechanic(_source, _get_target, _skill)
		print("[>] Mechanic: ", mechanic_run)
		return true
	else:
		print("[!] Can not run skill mechanic")
		return false

func CanRun(_source: Character, _target: Character, _skill: Skill):
	print("[>] Check Skill Condition")
	if condition == null:
		return true
	elif condition is AttributeCondition:
		print("[>] AttributeCondition")
		var _condition_attr: AttributeCondition = condition
		return _condition_attr.IsConditionMet(_source, _target, _skill)
	elif condition is SkillCondition:
		return true
	return false

func RunMechanic(_source: Character, _target: Character, _skill: Skill) -> bool:
	if _source == null or _target == null or _skill == null:
		return 0
	if mechanic is DamageMechanic:
		var _mechanic_dmg: DamageMechanic = mechanic
		_mechanic_dmg.Apply(_source, _target, _skill)
	elif mechanic is BuffMechanic:
		var _mechanic_buff: BuffMechanic = mechanic
		_mechanic_buff = _mechanic_buff.Apply(_source, _target, _skill)
	elif mechanic is SkillMechanic:
		return 0
	return 1