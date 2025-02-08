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
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> ", add_unit(unit_node_3d))
		else:
			print("UnitGroupModel >> ", name, " >> Add: ", unit_node, " >> This is not Unit Node: ")
	pass

func add_unit(unit: UnitNode3D):
	if unit == null:
		return false

	group.append(unit.unit_model)
	group_unit_node_3d.append(unit)
	unit.unit_model.set_node_3d(unit)
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

func is_fainted() -> bool:
	if group.size() == 0:
		return true
	var group_check = group.filter(func(x):
		if x.is_fainted:
			return true
	)
	return group_check.size() == group.size()

func update_position(gap: int = 1):
	if group_unit_node_3d.size() == 0:
		return
	# 	TH1:
	# y = 4
	# gap = 1
	# x = 3
	# D = 4 + 3 = 7
	# 	TH2:
	# y = 4
	# gap = 3
	# x = 3
	# D = 4 + 3.3 = 4 +  9 = 13
	# => D = y + x.gap
	if gap <= 0:
		gap = 1
	
	var y: float = group_unit_node_3d.size() * 1.0
	var d: int = int((y + (y - 1.0) * gap) / 2.0)
	var count: int = 0

	for i in range(-d, d + 1, gap + 1):
		group_unit_node_3d[count].position.x = i
		print("Unit: ", name, " position: ", group_unit_node_3d[count].position, " = ", i)
		count += 1
	return

# func has_unit(unit: UnitModel) -> bool:
# 	if unit == null:
# 		return false
# 	return group.find(func(x):
# 		return x == unit
# 	) != -1