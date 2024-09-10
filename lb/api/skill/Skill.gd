class_name Skill

var base: SkillBase
var name: String
var element: CharacterBase.Element

func _init(_base: SkillBase):
    if _base != null:
        self.base = _base
        self.name = _base.name
        self.element = _base.element

func CanUse(_char: Character) -> bool:
    if _char != null:
        return base.CanUse(_char)
    return false
