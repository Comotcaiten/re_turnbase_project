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
        print(name, " >> Add: ", add_unit_group(child))
    pass

func add_unit_group(group: UnitGroupModel) -> bool:
  return maps_groups.add(str(group.name), group)

func get_group(id: String) -> UnitGroupModel:
  if !maps_groups.get_value(id) is UnitGroupModel:
    return
  return maps_groups.get_value(id) as UnitGroupModel

func get_all() -> Array[UnitModel]:
  var arr: Array[UnitModel] = []
  for group in maps_groups.get_all_values():
    arr.append_array(group.group)
  return arr

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

func get_all_units_and_filter_fainted(is_fainted: bool = false) -> Array[UnitModel]:
  var all_units: Array[UnitModel]
  for group_model in maps_groups.get_all_values():
    if group_model is UnitGroupModel and group_model != null:
      all_units.append_array(group_model.group)
  all_units.filter(func(x):
    x.is_fainted = is_fainted)
  return all_units

func get_group_is_player(is_player: bool = true) -> UnitGroupModel:
  for group_model in maps_groups.get_all_values():
    if group_model is UnitGroupModel and group_model != null and group_model.is_player == is_player:
      return group_model
  return

func get_keys_group_is_player(is_player: bool = true) -> String:
  for keys in maps_groups.get_all_keys():
    var group_model: UnitGroupModel = maps_groups.get_value(keys) as UnitGroupModel
    if group_model != null and group_model.is_player == is_player:
      return keys
  return ""

func is_unit_in_any_group(unit: UnitModel):
  for group in maps_groups.get_all_values():
    if unit in group:
      return true
  return false

func find_group_of_unit(unit: UnitModel):
  for key in maps_groups.get_all_keys():
    if unit in maps_groups[key]:
      return key
  return

func filter_is_fainted(group: Array[UnitModel] = [], is_fainted: bool = false) -> Array[UnitModel]:
  var group_filter: Array[UnitModel] = group.filter( func(x):
    x.is_fainted = is_fainted)
  return group_filter