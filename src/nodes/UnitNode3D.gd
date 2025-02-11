extends Node3D

class_name UnitNode3D

var node_mesh_intstance_3d: MeshInstance3D

@export var color_fainted: Color = Color.html("#e74c3c")
@export var color_normal: Color = Color.html("#28b463")

@export var sprite_3d: Sprite3D = Sprite3D.new()

@export var sub_viewport: SubViewport = SubViewport.new()

@export var label_name: Label = Label.new()

@export var sub_viewport_selected: SubViewport = SubViewport.new()

@export var sprite_3d_selected: Sprite3D = Sprite3D.new()

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
  
  if sub_viewport == null:
    sub_viewport = SubViewport.new()
  sub_viewport.size = Vector2(250, 50)
  
  if sub_viewport_selected == null:
    sub_viewport_selected = SubViewport.new()
  sub_viewport_selected.size = Vector2(25, 25)

  var mesh_intstance_2d: MeshInstance2D = MeshInstance2D.new()
  mesh_intstance_2d.mesh = BoxMesh.new()
  mesh_intstance_2d.scale = Vector2(50, 50)
  
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

  add_child(sprite_3d_selected)
  sprite_3d_selected.position = Vector3(self.position.x, self.position.y + 2, self.position.z)
  add_child(sub_viewport_selected)
  sub_viewport_selected.add_child(mesh_intstance_2d)
  sprite_3d_selected.texture = sub_viewport_selected.get_texture()
  sprite_3d_selected.visible = false

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
    # sprite_3d_selected.visible = false
    return
  return

func seleted_by_skill():
  if unit_model == null:
    return
  sprite_3d_selected.visible = true
  if unit_model.is_fainted:
    return
  # node_mesh_intstance_3d.material_override.albedo_color = Color.html("#f1c40f")

func refresh():
  if unit_model == null:
    return
  label_name.text = unit_model.name + " [ " + str(unit_model.level) + " ]"
  return

func unseleted_by_skill():
  if unit_model == null:
    return
  sprite_3d_selected.visible = false
  if unit_model.is_fainted:
    return
  node_mesh_intstance_3d.material_override.albedo_color = color_normal
  return