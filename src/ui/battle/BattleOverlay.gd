extends Control

class_name BattleOverlay

# Lớp phủ gắn với World Space: dấu mục tiêu bấm được, số sát thương bay lên.
# Vị trí tính lại mỗi frame bằng cách chiếu vị trí 3D của unit lên màn hình,
# nên vẫn đúng khi camera đổi góc.

signal target_clicked(index: int)

const TARGET_ICON := preload("res://asset/icon_target.png")
const MARKER_SIZE := Vector2(56, 56)
const HEAD_OFFSET := Vector3(0, 0.9, 0)

var unit_nodes: Dictionary = {} # UnitModel -> UnitNode3D
var markers: Array[TextureButton] = []
var marker_units: Array[UnitModel] = []

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func register(nodes: Array[UnitNode3D]):
	unit_nodes.clear()
	for node in nodes:
		if node.unit_model != null:
			unit_nodes[node.unit_model] = node

func screen_position(unit: UnitModel) -> Variant:
	var node: UnitNode3D = unit_nodes.get(unit)
	var camera: Camera3D = get_viewport().get_camera_3d()
	if node == null or camera == null:
		return null
	var world: Vector3 = node.global_position + HEAD_OFFSET
	if camera.is_position_behind(world):
		return null
	return camera.unproject_position(world)

# available: các mục tiêu hợp lệ của skill; selected: các mục tiêu đang được chọn
func show_targets(available: Array, selected: Array, ally: bool):
	clear_targets()
	var color: Color = HUDStyle.ALLY_TARGET if ally else HUDStyle.TARGET
	for i in available.size():
		var unit: UnitModel = available[i]
		var marker := TextureButton.new()
		marker.texture_normal = TARGET_ICON
		marker.ignore_texture_size = true
		marker.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		marker.custom_minimum_size = MARKER_SIZE
		marker.size = MARKER_SIZE
		marker.focus_mode = Control.FOCUS_NONE
		marker.tooltip_text = unit.name
		var is_selected: bool = unit in selected
		marker.modulate = color if is_selected else Color(1, 1, 1, 0.35)
		marker.pivot_offset = MARKER_SIZE / 2.0
		if is_selected:
			var tween := marker.create_tween().set_loops()
			tween.tween_property(marker, "scale", Vector2.ONE * 1.12, 0.45)
			tween.tween_property(marker, "scale", Vector2.ONE, 0.45)
		marker.pressed.connect(func(): target_clicked.emit(i))
		add_child(marker)
		markers.append(marker)
		marker_units.append(unit)
	update_markers()

func clear_targets():
	for marker in markers:
		marker.queue_free()
	markers.clear()
	marker_units.clear()

func _process(_delta):
	update_markers()

func update_markers():
	for i in markers.size():
		var point: Variant = screen_position(marker_units[i])
		markers[i].visible = point != null
		if point != null:
			markers[i].position = point - MARKER_SIZE / 2.0

func _on_damage_after(dm: DamageModel):
	if dm.target == null:
		return
	if dm.is_miss:
		popup(dm.target, "Trượt", HUDStyle.TEXT_DIM, 20)
		return
	var color: Color = HUDStyle.CRIT if dm.is_crit else (Element.get_color(dm.element).lightened(0.35) if dm.element != Element.Type.PHYSICAL else HUDStyle.TEXT)
	var text: String = str(dm.damage_dealt)
	if dm.is_crit:
		text += "!"
	popup(dm.target, text, color, 34 if dm.is_crit else 26)
	if dm.element_multiplier > 1.0:
		popup(dm.target, "Khắc hệ", HUDStyle.BROKEN, 14, Vector2(0, -26))
	if dm.caused_break:
		popup(dm.target, "BREAK!", HUDStyle.BROKEN, 30, Vector2(0, -52))

func _on_healed(unit: UnitModel, amount: int):
	popup(unit, "+%d" % amount, HUDStyle.HEAL, 26)

# Chữ bay lên rồi mờ dần tại vị trí của unit
func popup(unit: UnitModel, text: String, color: Color, font_size: int, offset: Vector2 = Vector2.ZERO):
	var point: Variant = screen_position(unit)
	if point == null:
		return
	var label := HUDStyle.label(text, font_size, color)
	label.add_theme_constant_override("outline_size", 8)
	add_child(label)
	label.reset_size()
	label.position = point + offset + Vector2(randf_range(-24, 24), 0) - label.size / 2.0
	label.pivot_offset = label.size / 2.0
	label.scale = Vector2.ONE * 1.4
	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "scale", Vector2.ONE, 0.18)
	tween.tween_property(label, "position:y", label.position.y - 60, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate:a", 0.0, 0.4).set_delay(0.7)
	tween.chain().tween_callback(label.queue_free)
