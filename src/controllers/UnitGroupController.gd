extends Node

class_name UnitGroupController

var maps_groups: Maps = Maps.new(
	typeof(""),
	typeof(UnitGroupModel)
)

var battle_system: BattleSystem

func initialized(_battle_system: BattleSystem):
	battle_system = _battle_system
	for child in get_children():
		if child is UnitGroupModel:
			child.initialized()
			print(name, " >> Add: ", add_unit_group(child), " >> ", child, " >> ", child.group)
	
	for child in get_children():
		if child is UnitGroupModel:
			child.update_position()
	pass

func add_unit_group(group: UnitGroupModel) -> bool:
	return maps_groups.add(str(group.name), group)

func get_group(id: String) -> UnitGroupModel:
	if !maps_groups.get_value(id) is UnitGroupModel:
		return
	return maps_groups.get_value(id) as UnitGroupModel

func get_group_to_array(id: String) -> Array[UnitModel]:
	if !maps_groups.get_value(id) is UnitGroupModel:
		return []
	return maps_groups.get_value(id).group

func get_filter_is_not_fainted(id: String) -> Array[UnitModel]:
	if !maps_groups.get_value(id) is UnitGroupModel:
		return []
	return maps_groups.get_value(id).get_filter_is_not_fainted() as Array[UnitModel]

func get_all_units() -> Array[UnitModel]:
	var all_units: Array[UnitModel]
	for group_model in maps_groups.get_all_values():
		if group_model is UnitGroupModel and group_model != null:
			all_units.append_array(group_model.group)
	return all_units

func get_group_is_ally(unit: UnitModel) -> Array[UnitModel]:
	for group_model in maps_groups.get_all_values():
		if group_model is UnitGroupModel and group_model != null and unit in group_model.group:
			return group_model.group
	return []

func get_group_is_enemy(unit: UnitModel) -> Array[UnitModel]:
	for group_model in maps_groups.get_all_values():
		if group_model is UnitGroupModel and group_model != null and unit not in group_model.group:
			return group_model.group
	return []

func get_group_is_player() -> UnitGroupModel:
	for group_model in maps_groups.get_all_values():
		if group_model is UnitGroupModel and group_model != null and group_model.is_player:
			return group_model
	return

func filter_is_fainted(group: Array[UnitModel] = [], is_fainted: bool = false) -> Array[UnitModel]:
	var group_filter: Array[UnitModel] = group.filter(func(x):
		x.is_fainted = is_fainted)
	return group_filter

func is_one_group_fainted() -> bool:
	for group in maps_groups.get_all_values():
		if group.is_fainted():
			return true
	return false
