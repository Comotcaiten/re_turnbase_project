extends VBoxContainer

class_name TurnOrderPanel

# Left HUD: thứ tự lượt hành động. Chỉ hiển thị dữ liệu từ TurnController.get_preview(),
# không tự tính thứ tự.

const PREVIEW_COUNT := 7
const ITEM_SIZE := Vector2(132, 52)
const ACTIVE_SIZE := Vector2(156, 64)

var turn_controller: TurnController

func setup(_turn_controller: TurnController):
	turn_controller = _turn_controller
	add_theme_constant_override("separation", 6)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	refresh()

func refresh():
	HUDStyle.clear(self)
	if turn_controller == null:
		return
	var preview: Array[UnitModel] = turn_controller.get_preview(PREVIEW_COUNT)
	for i in preview.size():
		add_child(make_item(preview[i], i == 0))

func make_item(unit: UnitModel, is_active: bool) -> Control:
	var size: Vector2 = ACTIVE_SIZE if is_active else ITEM_SIZE
	var team_color: Color = HUDStyle.HP_PLAYER if unit.is_player else HUDStyle.HP_ENEMY

	var item := PanelContainer.new()
	item.custom_minimum_size = size
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg: Color = HUDStyle.PANEL_LIGHT if is_active else HUDStyle.PANEL
	var style := HUDStyle.box(bg, 6, 2 if is_active else 0, HUDStyle.ACCENT)
	# Vạch màu bên trái: xanh là phe ta, đỏ là phe địch
	style.border_width_left = 5
	style.border_color = HUDStyle.ACCENT if is_active else team_color
	style.set_content_margin_all(4)
	style.content_margin_left = 8
	item.add_theme_stylebox_override("panel", style)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.add_child(row)

	row.add_child(HUDStyle.portrait(unit, size.y - 10))

	var info := VBoxContainer.new()
	info.add_theme_constant_override("separation", 0)
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(info)

	var name_label := HUDStyle.label(unit.name, 14 if is_active else 12)
	name_label.clip_text = true
	info.add_child(name_label)
	var sub: String = "ĐANG HÀNH ĐỘNG" if is_active else ("SPD %d" % unit.speed)
	if unit.is_broken:
		sub = "BREAK"
	info.add_child(HUDStyle.label(sub, 10, HUDStyle.BROKEN if unit.is_broken else (HUDStyle.ACCENT if is_active else HUDStyle.TEXT_DIM)))

	if not is_active:
		item.modulate = Color(1, 1, 1, 0.85)
	return item
