class_name SkillModel

var base: SkillBase

var name: String
var element: Element.Type

var target_type: SkillBase.TargetType
var target_mode: SkillBase.TargetMode

func _init(_base: SkillBase):
	base = _base
	name = _base.name
	element = _base.element

	target_type = _base.target_type
	target_mode = _base.target_mode
	pass

func excute(unit: UnitModel, targets: Array[UnitModel]):
	# First: Check if the skill can be used
	# Check targets
	if targets.is_empty():
		return false
	
	for component in base.components:
		if not component.run(unit, targets):
			return false
	pass
