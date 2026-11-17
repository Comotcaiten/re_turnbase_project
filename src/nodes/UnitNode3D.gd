extends Node3D

class_name UnitNode3D

var node_mesh_intstance_3d: MeshInstance3D

var base: UnitBase
var level: int = 1:
  get():
    return max(1, level)

var unit_model: UnitModel

var is_player: bool = false

var items: Array[ItemBase] = []

const BAR_WIDTH := 1.2
var hp_bar: MeshInstance3D
var break_bar: MeshInstance3D
var label: Label3D

func _init(_base: UnitBase, _level: int = 1, _is_player: bool = false, _items: Array[ItemBase] = []):
  node_mesh_intstance_3d = MeshInstance3D.new()
  node_mesh_intstance_3d.mesh = BoxMesh.new()

  add_child(node_mesh_intstance_3d)

  # Camera nhìn từ trên xuống: -Z là phía trên màn hình
  create_bar(Color.BLACK, -0.75, 0.55)
  create_bar(Color.BLACK, -0.95, 0.55)
  hp_bar = create_bar(Color.GREEN, -0.75, 0.6)
  break_bar = create_bar(Color.ORANGE, -0.95, 0.6)

  label = Label3D.new()
  label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
  label.no_depth_test = true
  label.pixel_size = 0.01
  label.font_size = 28
  label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
  label.position = Vector3(0, 0.6, 0.8)
  add_child(label)

  base = _base
  level = _level
  is_player = _is_player
  items = _items

  initialized()
  pass

func initialized():
  if base == null or level < 0:
    return false
  unit_model = UnitModel.new(base, level)
  unit_model.is_player = is_player

  var material := StandardMaterial3D.new()
  material.albedo_color = Element.get_color(base.element)
  node_mesh_intstance_3d.material_override = material

  for item in items:
    unit_model.equip_item(item)
  print("UnitNode3D >> ", name, " >> Initialized: ", unit_model)
  unit_model.changed.connect(update)
  update()
  return true

func update():
  if unit_model == null:
    return

  visible = not unit_model.is_fainted
  set_bar(hp_bar, float(unit_model.health) / maxi(1, unit_model.max_health))
  set_bar(break_bar, float(unit_model.break_gauge) / maxi(1, unit_model.max_break))

  var text: String = "%s\n%s Lv.%d" % [unit_model.name, Role.get_display_name(unit_model.base.role), unit_model.level]
  if not unit_model.items.is_empty():
    text += "\n%d item" % unit_model.items.size()
  for status in unit_model.statuses:
    text += "\n%s (%d)" % [status.effect.name, status.turns_left]
  label.text = text
  return

func set_highlight(is_active: bool, is_targeted: bool):
  if is_targeted:
    label.modulate = Color.YELLOW
  elif is_active:
    label.modulate = Color.AQUA
  else:
    label.modulate = Color.WHITE

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