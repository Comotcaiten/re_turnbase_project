extends Node

class_name UnitGroupModel

var group: Array[UnitModel]

@export var is_player: bool = true

func initialized():
  for child in get_children():
    if child is UnitNode:
      child.initialized()
      child.unit_model.is_player = is_player
      print(name, " >> Add: ", add_unit(child.unit_model))

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