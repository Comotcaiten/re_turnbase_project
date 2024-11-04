extends Node
class_name UnitCombatantController

@export var is_player_party: bool

var childs: Array[UnitModel] = []

func initialize():
    var _childs: Array[UnitModel]
    for child in get_children():
        if child is UnitModel:
            _childs.append(child)
            child.initialize()
            child.is_player = is_player_party
    childs = _childs
    childs.sort_custom(sort_by_speed)
    return

func get_all_unit():
    return childs

static func sort_by_speed(a, b):
    return a.stats_controller.speed > b.stats_controller.speed