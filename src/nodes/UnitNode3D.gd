extends Node3D

class_name UnitNode3D

var node_mesh_intstance_3d: MeshInstance3D

var base: UnitBase
var level: int = 1:
  get():
    return max(1, level)

var unit_model: UnitModel

var is_player: bool = false

const BAR_WIDTH := 1.2
var hp_bar: MeshInstance3D
var break_bar: MeshInstance3D

func _init(_base: UnitBase, _level: int = 1, _is_player: bool = false):
  node_mesh_intstance_3d = MeshInstance3D.new()
  node_mesh_intstance_3d.mesh = BoxMesh.new()

  add_child(node_mesh_intstance_3d)

  # Camera nhìn từ trên xuống: -Z là phía trên màn hình
  create_bar(Color.BLACK, -0.75, 0.55)
  create_bar(Color.BLACK, -0.95, 0.55)
  hp_bar = create_bar(Color.GREEN, -0.75, 0.6)
  break_bar = create_bar(Color.ORANGE, -0.95, 0.6)

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
  BattleEvents.damage_after.connect(_on_damage_after)
  BattleEvents.break_recovered.connect(_on_break_recovered)
  update()
  return true

func update():
  if unit_model == null:
    return

  visible = not unit_model.is_fainted
  set_bar(hp_bar, float(unit_model.health) / maxi(1, unit_model.max_health))
  set_bar(break_bar, float(unit_model.break_gauge) / maxi(1, unit_model.max_break))
  return

func create_bar(color: Color, z: float, y: float) -> MeshInstance3D:
  var material := StandardMaterial3D.new()
  material.albedo_color = color
  material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

  var mesh := BoxMesh.new()
  mesh.size = Vector3(BAR_WIDTH, 0.05, 0.14)
  mesh.material = material

  var bar := MeshInstance3D.new()
  bar.mesh = mesh
  bar.position = Vector3(0, y, z)
  add_child(bar)
  return bar

func set_bar(bar: MeshInstance3D, ratio: float):
  bar.visible = ratio > 0.0
  if bar.visible:
    bar.scale.x = ratio
    bar.position.x = -BAR_WIDTH * (1.0 - ratio) / 2.0
  return

func _on_damage_after(damage_model: DamageModel):
  if damage_model.target == unit_model:
    update()

func _on_break_recovered(unit: UnitModel):
  if unit == unit_model:
    update()