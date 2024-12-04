extends Node
class_name UnitGroupModel

@export var is_group_player: bool

var group: Array[UnitModel]:
  get:
    return get_units()

func _ready():
  print(get_units())
  pass

func get_units() -> Array[UnitModel]:
  var new_group: Array[UnitModel]
  for child in get_children():
    if (child is UnitModel):
      child.is_player = is_group_player
      new_group.append(child)
  return new_group