class_name SkillModel

var base: SkillBase

var name: String
var element: Element.Type

func _init(_base: SkillBase):
    base = _base
    name = _base.name
    element = _base.element
    pass