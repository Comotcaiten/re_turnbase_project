extends Node
class_name UnitGroupModel

@export var is_group_player: bool

var id: String:
  get:
    return "UGD#" + str(self.get_instance_id())

var group: Array[UnitModel]:
  get:
    return get_units()

func _ready():
  get_ready()
  pass

# Tạm thời để 2 cái function giống nhau để sau suy nghĩ lại cách fix
func get_units() -> Array[UnitModel]:
  var new_group: Array[UnitModel]
  for child in get_children():
    if (child is UnitModel):
      child.is_player = is_group_player
      child.id_groups = id
      new_group.append(child)
  return new_group

func get_ready():
  var new_group: Array[UnitModel]
  for child in get_children():
    if (child is UnitModel):
      child.is_player = is_group_player
      child.id_groups = id
      new_group.append(child)
  group = new_group
  return