extends Node

class_name BattleSystem

@export var node_groups: Array[UnitGroupNode] = []
@export var unit_controller: UnitController = UnitController.new()

func _ready():
    if node_groups.size() == 2:
        for group in node_groups:
            unit_controller.set_team(group.unit_group, group.team)

    if node_groups.size() == 2:
        for group in node_groups:
            for unit_node in group.unit_nodes:
                print(unit_controller.add_unit(UnitModel.new(unit_node.base, unit_node.level), group.team))
    pass