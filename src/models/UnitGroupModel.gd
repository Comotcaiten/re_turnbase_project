extends Node

class_name UnitGroupModel

var group: Array[UnitModel]

@export var is_player: bool = true

@export var data_unit_node: Array[UnitNode] = []

var group_unit_node_3d: Array[UnitNode3D] = []

func initialized():
	for unit_node in data_unit_node:
		if unit_node is UnitNode:
			var unit_node_3d: UnitNode3D = UnitNode3D.new(unit_node.base, unit_node.level, is_player)
			add_child(unit_node_3d)
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> UnitModel: ", unit_node_3d.unit_model)
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> ", add_unit(unit_node_3d.unit_model))
		else:
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> This is not Unit Node: ")
	pass

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
