extends VBoxContainer

class_name CharacterSlot

# Một ô nhân vật ở Bottom HUD: ảnh, tên, HP, MP, hiệu ứng, trạng thái lượt.
# Tự cập nhật khi UnitModel.changed phát.

const SLOT_SIZE := Vector2(200, 92)

var unit: UnitModel
var style: StyleBoxFlat
var hp_bar: ProgressBar
var mp_bar: ProgressBar
var hp_label: Label
var tag_label: Label
var status_row: HBoxContainer
var portrait: Control
var card: PanelContainer
var lift: Control # Khoảng trống phía dưới, tăng lên để ô đang hành động nhô cao

func setup(_unit: UnitModel, key: String = ""):
	unit = _unit
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_constant_override("separation", 0)
	size_flags_vertical = Control.SIZE_SHRINK_END
	card = PanelContainer.new()
	card.custom_minimum_size = SLOT_SIZE
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	style = HUDStyle.box(HUDStyle.PANEL, 8, 1)
	style.set_content_margin_all(6)
	card.add_theme_stylebox_override("panel", style)
	add_child(card)
	lift = Control.new()
	lift.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(lift)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(row)

	var left := VBoxContainer.new()
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left.add_theme_constant_override("separation", 2)
	row.add_child(left)
	portrait = HUDStyle.portrait(unit, 58)
	left.add_child(portrait)
	if key != "":
		var hint := HUDStyle.key_hint(key)
		hint.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		left.add_child(hint)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 3)
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(info)

	var name_row := HBoxContainer.new()
	name_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(name_row)
	var name_label := HUDStyle.label(unit.name, 14)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.clip_text = true
	name_row.add_child(name_label)
	tag_label = HUDStyle.label("", 11, HUDStyle.ACCENT)
	name_row.add_child(tag_label)

	hp_label = HUDStyle.label("", 18)
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	info.add_child(hp_label)
	hp_bar = HUDStyle.bar(HUDStyle.HP_PLAYER, 7)
	info.add_child(hp_bar)
	mp_bar = HUDStyle.bar(HUDStyle.MP, 4)
	mp_bar.tooltip_text = "MP"
	info.add_child(mp_bar)

	status_row = HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 3)
	status_row.custom_minimum_size = Vector2(0, 16)
	info.add_child(status_row)

	unit.changed.connect(refresh)
	refresh()

func refresh():
	hp_label.text = str(unit.health)
	hp_bar.value = float(unit.health) / maxi(1, unit.max_health)
	mp_bar.value = float(unit.mp) / maxi(1, unit.max_mp)
	hp_bar.tooltip_text = "HP %d/%d" % [unit.health, unit.max_health]
	HUDStyle.set_bar_color(hp_bar, HUDStyle.TARGET if hp_bar.value <= 0.3 else HUDStyle.HP_PLAYER)
	HUDStyle.clear(status_row)
	for status in unit.statuses:
		status_row.add_child(HUDStyle.status_chip(status))
	card.modulate = Color(0.45, 0.45, 0.5) if unit.is_fainted else Color.WHITE

# is_active: đang tới lượt; is_targeted: đang là mục tiêu của skill phe ta/phe địch
func set_state(is_active: bool, is_targeted: bool):
	if unit.is_fainted:
		tag_label.text = "GỤC"
		tag_label.add_theme_color_override("font_color", HUDStyle.TEXT_DIM)
		style.set_border_width_all(1)
		style.border_color = HUDStyle.BORDER
		position_offset(0)
		return
	if is_targeted:
		tag_label.text = "MỤC TIÊU"
		tag_label.add_theme_color_override("font_color", HUDStyle.ALLY_TARGET)
		style.border_color = HUDStyle.ALLY_TARGET
		style.set_border_width_all(2)
	elif is_active:
		tag_label.text = "LƯỢT"
		tag_label.add_theme_color_override("font_color", HUDStyle.ACCENT)
		style.border_color = HUDStyle.ACCENT
		style.set_border_width_all(2)
	else:
		tag_label.text = ""
		style.border_color = HUDStyle.BORDER
		style.set_border_width_all(1)
	style.bg_color = HUDStyle.PANEL_LIGHT if is_active else HUDStyle.PANEL
	position_offset(-14 if is_active else 0)

# Ô của nhân vật đang hành động nhô lên một chút
func position_offset(value: float):
	var tween := create_tween()
	tween.tween_property(lift, "custom_minimum_size:y", absf(value), 0.15)
