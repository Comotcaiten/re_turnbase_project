extends Resource

class_name SkillComponent

@export var conditions: Array[SkillCondition]
@export var mechanics: Array[SkillMechanic]

func run(unit: UnitModel, targets: Array[UnitModel]):
	if not check(unit, targets):
		return false
	for mechanic in mechanics:
		mechanic.apply_mechanic(unit, targets)
	return true

func check(unit: UnitModel, targets: Array[UnitModel]) -> bool:
	if conditions.is_empty():
		return true
	for condition in conditions:
		if not condition.check(unit, targets):
			return false
	return true