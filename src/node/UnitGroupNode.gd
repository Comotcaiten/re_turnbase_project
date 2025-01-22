extends Node

class_name UnitGroupNode

@export var is_player_group: bool

var group: Array[UnitNode]

func set_up():
    for child in get_children():
        if child is UnitNode:
            child.set_up()
            add_unit_node(child)

func add_unit_node(unit: UnitNode):
    if unit == null:
        return false
    if unit in group:
        return false
    group.append(unit)
    return true