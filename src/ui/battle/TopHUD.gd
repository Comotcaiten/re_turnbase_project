extends Control

class_name TopHUD

# Top HUD: thông tin kẻ địch đang được chú ý (mục tiêu đang chọn, hoặc địch đang hành động)
# ở giữa, nút điều khiển trận (Tự động / x2 / Tạm dừng) ở góc phải.

signal auto_toggled(enabled: bool)
signal speed_toggled(fast: bool)
signal pause_pressed

var info_panel: PanelContainer
var portrait_holder: Control
var name_label: Label
var sub_label: Label
var hp_bar: ProgressBar
var hp_label: Label
var break_bar: ProgressBar
var status_row: HBoxContainer
var auto_button: Button
var speed_button: Button

var focus: UnitModel

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	build_enemy_info()
	build_controls()

func build_enemy_info():
	var center := CenterContainer.new()
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	center.offset_top = 10

	info_panel = HUDStyle.panel(HUDStyle.PANEL, 8, 8)
	info_panel.custom_minimum_size = Vector2(380, 0)
	info_panel.visible = false
	center.add_child(info_panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info_panel.add_child(row)

	portrait_holder = Control.new()
	portrait_holder.custom_minimum_size = Vector2(46, 46)
	portrait_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(portrait_holder)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 3)
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(info)

	var head := HBoxContainer.new()
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(head)
	name_label = HUDStyle.label("", 18)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(name_label)
	hp_label = HUDStyle.label("", 12, HUDStyle.TEXT_DIM)
	head.add_child(hp_label)

	hp_bar = HUDStyle.bar(HUDStyle.HP_ENEMY, 8)
	info.add_child(hp_bar)
	break_bar = HUDStyle.bar(HUDStyle.BREAK, 4)
	break_bar.tooltip_text = "Thanh Break: chỉ giảm khi trúng đòn khắc hệ"
	info.add_child(break_bar)

	var bottom := HBoxContainer.new()
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(bottom)
	sub_label = HUDStyle.label("", 11, HUDStyle.TEXT_DIM)
	sub_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.add_child(sub_label)
	status_row = HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 3)
	bottom.add_child(status_row)

func build_controls():
	var bar := HUDStyle.panel(HUDStyle.PANEL, 8, 4)
	add_child(bar)
	bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	bar.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	bar.offset_top = 10
	bar.offset_right = -12

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	bar.add_child(row)

	auto_button = make_toggle("AUTO", "Tự động chiến đấu")
	auto_button.toggled.connect(func(on): auto_toggled.emit(on))
	row.add_child(auto_button)
	speed_button = make_toggle("x2", "Tăng tốc độ trận đấu")
	speed_button.toggled.connect(func(on): speed_toggled.emit(on))
	row.add_child(speed_button)
	var pause := make_toggle("II", "Tạm dừng (Esc)")
	pause.toggle_mode = false
	pause.pressed.connect(func(): pause_pressed.emit())
	row.add_child(pause)

func make_toggle(text: String, tip: String) -> Button:
	var button := Button.new()
	button.text = text
	button.tooltip_text = tip
	button.toggle_mode = true
	button.focus_mode = Control.FOCUS_NONE
	button.custom_minimum_size = Vector2(52, 34)
	button.add_theme_font_size_override("font_size", 14)
	button.add_theme_stylebox_override("normal", HUDStyle.box(Color(0, 0, 0, 0), 6))
	button.add_theme_stylebox_override("hover", HUDStyle.box(Color(1, 1, 1, 0.1), 6))
	button.add_theme_stylebox_override("pressed", HUDStyle.box(Color(HUDStyle.ACCENT, 0.35), 6, 1, HUDStyle.ACCENT))
	button.add_theme_stylebox_override("hover_pressed", HUDStyle.box(Color(HUDStyle.ACCENT, 0.45), 6, 1, HUDStyle.ACCENT))
	return button

func set_focus(unit: UnitModel):
	if focus != null and focus.changed.is_connected(refresh):
		focus.changed.disconnect(refresh)
	focus = unit
	info_panel.visible = focus != null
	if focus == null:
		return
	focus.changed.connect(refresh)
	HUDStyle.clear(portrait_holder)
	var picture := HUDStyle.portrait(focus, 46, true)
	portrait_holder.add_child(picture)
	refresh()

func refresh():
	if focus == null:
		return
	name_label.text = focus.name
	hp_label.text = "%d / %d" % [focus.health, focus.max_health]
	hp_bar.value = float(focus.health) / maxi(1, focus.max_health)
	break_bar.value = float(focus.break_gauge) / maxi(1, focus.max_break)
	HUDStyle.set_bar_color(break_bar, HUDStyle.BROKEN if focus.is_broken else HUDStyle.BREAK)
	var weak: Array[String] = []
	for attack in Element.Type.values():
		if Element.get_multiplier(attack, focus.element) > 1.0:
			weak.append(Element.get_display_name(attack))
	var text: String = "Lv.%d  ·  Hệ %s" % [focus.level, Element.get_display_name(focus.element)]
	if not weak.is_empty():
		text += "  ·  Yếu: %s" % ", ".join(weak)
	if focus.is_broken:
		text += "  ·  BREAK"
	sub_label.text = text
	HUDStyle.clear(status_row)
	for status in focus.statuses:
		status_row.add_child(HUDStyle.status_chip(status))

func set_auto(enabled: bool):
	auto_button.set_pressed_no_signal(enabled)
