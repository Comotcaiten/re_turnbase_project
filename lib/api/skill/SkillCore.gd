extends Resource
class_name SkillCore

@export var name: String
@export_group("If SkillAbility (*)")
@export var abilityIf: SkillAbility
@export_group("Else SkillAbility")
@export var abilityElse: SkillAbility

func _RunCore(_source: Character, _target: Character,  _skill: Skill):
	if abilityIf == null:
		return 0
	if abilityIf.CanApply(_source, _target, _skill):
		return 1
	else:
		if abilityElse == null:
			return 0
		if abilityElse.CanApply(_source, _target, _skill):
			return 1
	return 0    
