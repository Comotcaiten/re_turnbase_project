extends Node3D

class_name UnitNode3D

var node_mesh_intstance_3d: MeshInstance3D

@export var color_fainted: Color = Color.html("#e74c3c")
@export var color_normal: Color = Color.html("#28b463")

@export var sprite_3d: Sprite3D

@export var sub_viewport: SubViewport

@export var label_name: Label

var base: UnitBase
var level: int = 1:
  get():
    return max(1, level)

var unit_model: UnitModel

var is_player: bool = false

func _init(_base: UnitBase, _level: int = 1, _is_player: bool = false):
  base = _base
  level = _level
  is_player = _is_player

  initialized()

  if node_mesh_intstance_3d == null:
    node_mesh_intstance_3d = MeshInstance3D.new()
    node_mesh_intstance_3d.mesh = BoxMesh.new()
  node_mesh_intstance_3d.material_override = StandardMaterial3D.new()
  node_mesh_intstance_3d.material_override.albedo_color = color_normal

  if sprite_3d == null:
    sprite_3d = Sprite3D.new()
  
  if sub_viewport == null:
    sub_viewport = SubViewport.new()
    sub_viewport.size = Vector2(250, 50)
  
  if label_name == null:
    label_name = Label.new()
    label_name.text = str(self) + " [ " + str(_level) + " ]"

    label_name.size = Vector2(250, 50)

    label_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

  add_child(node_mesh_intstance_3d)

  add_child(sprite_3d)
  sprite_3d.position = Vector3(self.position.x, self.position.y + 1, self.position.z)

  add_child(sub_viewport)
  sub_viewport.add_child(label_name)

  sprite_3d.texture = sub_viewport.get_texture()
  print("UnitNode3D >> ", name, " >> Initialized: ", base, " >> ", level)
  return

func initialized():
  if base == null or level < 0:
    return false
  unit_model = UnitModel.new(base, level)
  unit_model.is_player = is_player
  print("UnitNode3D >> ", name, " >> Initialized: ", unit_model)
  return true

func update():
  if unit_model == null:
    return

  if unit_model.is_fainted:
    # node_mesh_intstance_3d.visible = false
    node_mesh_intstance_3d.material_override.albedo_color = color_fainted
    return
  return

func seleted_by_skill():
  if unit_model == null:
    return
  if unit_model.is_fainted:
    return
  node_mesh_intstance_3d.material_override.albedo_color = Color.html("#f1c40f")

func refresh():
  if unit_model == null:
    return
  label_name.text = unit_model.name + " [ " + str(unit_model.level) + " ]"
  return

func unseleted_by_skill():
  if unit_model == null:
    return
  if unit_model.is_fainted:
    return
  node_mesh_intstance_3d.material_override.albedo_color = color_normal
  return