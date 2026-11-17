extends Button

class_name UnitIcon

# Ô nhân vật: dùng UnitBase.icon nếu có, không thì vẽ ô màu theo hệ kèm chữ cái đầu.

const SIZE := Vector2(116, 116)
const EMPTY_COLOR := Color(0.2, 0.2, 0.24)
const CAPTION_HEIGHT := 44.0

func _init():
	custom_minimum_size = SIZE
	focus_mode = Control.FOCUS_NONE

# unit == null là ô trống
func setup(unit: OwnedUnit, marked: bool = false):
	var color: Color = EMPTY_COLOR if unit == null else Element.get_color(unit.base.element).darkened(0.2)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(8)
	style.set_border_width_all(4 if marked else 0)
	style.border_color = Color.GOLD
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		add_theme_stylebox_override(state, style)

	if unit == null:
		add_centered_label("+", 40)
		return

	if unit.base.icon != null:
		var picture := TextureRect.new()
		picture.texture = unit.base.icon
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(picture)
		picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		add_centered_label(unit.base.name.left(1), 40, CAPTION_HEIGHT)

	var caption := Label.new()
	caption.text = "%s\nLv.%d" % [unit.base.name, unit.level]
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 14)
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(caption)
	caption.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	caption.grow_vertical = Control.GROW_DIRECTION_BEGIN

func add_centered_label(value: String, font_size: int, bottom_space: float = 0.0):
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.offset_bottom = -bottom_space
