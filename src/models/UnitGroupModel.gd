extends Node

class_name UnitGroupModel

var group: Array[UnitModel]

@export var is_player: bool = true

@export var data_unit_node: Array[UnitNode] = []

var group_unit_node_3d: Array[UnitNode3D] = []

const UNIT_SPACING := 2.5

func initialized():
	var unit_nodes: Array[UnitNode] = get_unit_nodes()
	for i in unit_nodes.size():
		var unit_node: UnitNode = unit_nodes[i]
		if unit_node is UnitNode:
			var unit_node_3d: UnitNode3D = UnitNode3D.new(unit_node.base, unit_node.level, is_player, unit_node.items)
			add_child(unit_node_3d)
			unit_node_3d.position.x = (i - (unit_nodes.size() - 1) / 2.0) * UNIT_SPACING
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> UnitModel: ", unit_node_3d.unit_model)
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> ", add_unit(unit_node_3d.unit_model))
		else:
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> This is not Unit Node: ")
	pass

func get_unit_nodes() -> Array[UnitNode]:
	if is_player and not PlayerCollection.battle_team.is_empty():
		return PlayerCollection.battle_team
	return data_unit_node

func add_unit(unit: UnitModel):
	if unit in group or unit == null:
		return false
	group.append(unit)
	return true

func remove_unit(unit: UnitModel):
	if !unit in group or unit == null:
		return false
	group.erase(unit)
	return true

func get_group() -> Array[UnitModel]:
	return group

func get_filter_is_fainted():
	return group.filter(func(x):
		return x.is_fainted
)

func get_filter_is_not_fainted():
	return group.filter(func(x):
		return !x.is_fainted
)
