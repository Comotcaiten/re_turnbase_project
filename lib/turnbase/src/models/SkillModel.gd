class_name SkillModel

var base: SkillBase
var element: ElementBase.Type

func _init(_base: SkillBase) -> void:
    base = _base
    element = _base.element

func use(_target: UnitModel, _source: UnitModel, _skill: SkillModel):
    if base.component_if == null:
        return false
    elif base.component_if.run_component(_target, _source, _skill):
        return true
    elif base.component_else == null:
        return false
    elif base.component_if.run_component(_target, _source, _skill):
        return true
    return false