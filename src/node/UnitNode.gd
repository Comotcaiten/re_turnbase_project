extends Node

class_name UnitNode

@export var base: UnitBase
@export var level: int

# @export var label_hp: Label
# @export var label_name: Label

var unit_model: UnitModel

func set_up() -> bool:
    if base == null or level <= 0:
        return false
    unit_model = UnitModel.new(base, level)
    return true