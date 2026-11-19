extends VBoxContainer

class_name CombatActionPanel

# Right HUD: các skill của nhân vật đang hành động + nút xác nhận.
# Chỉ gửi lựa chọn sang SkillController, không tự giữ trạng thái chọn.

const KEYS := ["1", "2", "3", "4"]
const SMALL := 64.0
const BIG := 92.0

var controller: SkillController
var skill_row: HBoxContainer
var mode_label: Label
var description_label: Label

func setup(_controller: SkillController):
	controller = _controller
	alignment = BoxContainer.ALIGNMENT_END
	add_theme_constant_override("separation", 6)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	description_label = HUDStyle.label("", 12, HUDStyle.TEXT_DIM)
	description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description_label.custom_minimum_size = Vector2(320, 0)
	add_child(description_label)

	skill_row = HBoxContainer.new()
	skill_row.alignment = BoxContainer.ALIGNMENT_END
	skill_row.add_theme_constant_override("separation", 10)
	skill_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(skill_row)

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	footer.add_theme_constant_override("separation", 8)
	footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(footer)
	mode_label = HUDStyle.label("", 13, HUDStyle.TEXT)
	footer.add_child(mode_label)
	var confirm := Button.new()
	confirm.text = "Xác nhận  [Enter]"
	confirm.focus_mode = Control.FOCUS_NONE
	confirm.custom_minimum_size = Vector2(150, 38)
	confirm.add_theme_font_size_override("font_size", 15)
	confirm.add_theme_stylebox_override("normal", HUDStyle.box(Color(HUDStyle.TARGET, 0.85), 19))
	confirm.add_theme_stylebox_override("hover", HUDStyle.box(HUDStyle.TARGET.lightened(0.15), 19))
	confirm.add_theme_stylebox_override("pressed", HUDStyle.box(HUDStyle.TARGET.darkened(0.2), 19))
	confirm.pressed.connect(controller.confirm)
	footer.add_child(confirm)

	visible = false

func refresh(unit: UnitModel):
	var selecting: bool = controller.state == SkillController.State.SELECT
	visible = selecting
	if not selecting:
		return
	HUDStyle.clear(skill_row)
	for i in unit.skills.size():
		skill_row.add_child(make_skill(unit, i, i == controller.current_index))
	var skill: SkillModel = controller.current_skill
	if skill == null:
		mode_label.text = ""
		description_label.text = ""
		return
	mode_label.text = "%s  ·  ◀ ▶ đổi mục tiêu" % HUDStyle.target_mode_text(skill)
	description_label.text = skill.base.description

func make_skill(unit: UnitModel, index: int, selected: bool) -> Control:
	var skill: SkillModel = unit.skills[index]
	var size: float = BIG if selected else SMALL
	var color: Color = Element.get_color(skill.element)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_END
	column.add_theme_constant_override("separation", 2)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if index < KEYS.size():
		var hint := HUDStyle.key_hint(KEYS[index])
		hint.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		column.add_child(hint)

	var button := Button.new()
	button.custom_minimum_size = Vector2(size, size)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.focus_mode = Control.FOCUS_NONE
	button.text = skill.name.left(2) if not selected else skill.name.left(4)
	button.tooltip_text = "%s\n%s\n%s" % [skill.name, HUDStyle.target_mode_text(skill), skill.base.description]
	button.add_theme_font_size_override("font_size", 22 if selected else 16)
	var radius: int = int(size / 2.0)
	var border: Color = Color.WHITE if selected else color.lightened(0.3)
	button.add_theme_stylebox_override("normal", HUDStyle.box(color.darkened(0.45 if not selected else 0.15), radius, 3 if selected else 2, border))
	button.add_theme_stylebox_override("hover", HUDStyle.box(color.darkened(0.05), radius, 3, Color.WHITE))
	button.add_theme_stylebox_override("pressed", HUDStyle.box(color, radius, 3, Color.WHITE))
	button.pressed.connect(func():
		# Bấm lại skill đang chọn = xác nhận, giống thao tác nhanh trên mobile
		if controller.current_index == index:
			controller.confirm()
		else:
			controller.select_skill(index, unit)
	)
	column.add_child(button)

	var caption := HUDStyle.label(skill.name, 12, HUDStyle.TEXT if selected else HUDStyle.TEXT_DIM)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(caption)
	return column
