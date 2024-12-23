extends Node
class_name UnitGroupModel

@export var is_group_player: bool

var id: String:
  get:
    return "UGD#" + str(self.get_instance_id())

var group: Array[UnitModel]:
  get:
    return get_units()

func get_units() -> Array[UnitModel]:
  var new_group: Array[UnitModel]
  for child in get_children():
    if (child is UnitModel):
      child.is_player = is_group_player
      child.id_groups = id
      new_group.append(child)
  return new_group

func get_groups_filter(fainted: bool = false) -> Array[UnitModel]:
  if fainted:
    return group.filter(filter_is_fainted)
  return group.filter(filter_is_not_fainted)

func filter_is_not_fainted(a: UnitModel):
  return !a.is_fainted

func filter_is_fainted(a: UnitModel):
  return a.is_fainted

func is_fainted():
  if get_groups_filter(true).is_empty():
    return false
  return true

func health_info():
  print("<<<<[", id, "]>>>>")
  for unit in group:
    print(unit.name, ": HP[", unit.health, "/", unit.max_health)