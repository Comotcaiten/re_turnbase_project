class_name Skill

var base: SkillBase
var name: String
var element: CharacterBase.Element

func _init(_base: SkillBase):
	if _base != null:
		self.base = _base
		self.name = _base.name
		self.element = _base.element

# func CanUse(_char: Character) -> bool:
#     if _char != null:
#         return base.CanUse(_char)
#     return false

func CanUse(_charc: Character) -> bool:
	match base.cost_type:
		SkillBase.CostType.MP:
			return _charc.mp >= base.cost_amount
		SkillBase.CostType.HP:
			return _charc.hp >= base.cost_amount
		SkillBase.CostType.OTHER:
			return false
	return false

func _RunCore(_source: Character, _target: Character):
	base.core._RunCore(_source, _target, self)
	return
