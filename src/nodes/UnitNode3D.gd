extends Node3D

class_name UnitNode3D

var node_mesh_intstance_3d: MeshInstance3D

var color_fainted: Color = Color.html("#e74c3c")
var color_normal: Color = Color.html("#28b463")

var base: UnitBase
var level: int = 1:
  get():
    return max(1, level)

var unit_model: UnitModel

var is_player: bool = false

func _init(_base: UnitBase, _level: int = 1, _is_player: bool = false):
  node_mesh_intstance_3d = MeshInstance3D.new()
  node_mesh_intstance_3d.mesh = BoxMesh.new()
  node_mesh_intstance_3d.material_override = StandardMaterial3D.new()
  node_mesh_intstance_3d.material_override.albedo_color = color_normal

  add_child(node_mesh_intstance_3d)

  base = _base
  level = _level
  is_player = _is_player

  initialized()
  pass

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