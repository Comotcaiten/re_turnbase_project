extends CanvasLayer

const DEFAULT_SCENE := "res://scene/default.tscn"
const MAX_LOG_LINES := 9

@export var battle_system: BattleSystem

var turn_label: Label
var log_label: Label
var skill_row: HBoxContainer
var target_row: HBoxContainer
var result_panel: PanelContainer
var result_label: Label
var log_lines: PackedStringArray = []

@onready var controller: SkillController = battle_system.skill_controller

func _ready():
	build_layout()
	controller.selection_changed.connect(refresh_actions)
	BattleEvents.turn_started.connect(_on_turn_started)
	BattleEvents.turn_skipped.connect(_on_turn_skipped)
	BattleEvents.damage_after.connect(_on_damage_after)
	BattleEvents.status_applied.connect(_on_status_applied)
	BattleEvents.battle_ended.connect(_on_battle_ended)

func build_layout():
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	turn_label = Label.new()
	turn_label.add_theme_font_size_override("font_size", 24)
	turn_label.position = Vector2(24, 16)
	root.add_child(turn_label)

	log_label = Label.new()
	log_label.add_theme_font_size_override("font_size", 14)
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	log_label.position = Vector2(920, 16)
	log_label.size = Vector2(340, 400)
	root.add_child(log_label)

	var actions := VBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	root.add_child(actions)
	actions.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE, Control.PRESET_MODE_MINSIZE, 16)
	actions.grow_vertical = Control.GROW_DIRECTION_BEGIN

	skill_row = HBoxContainer.new()
	skill_row.add_theme_constant_override("separation", 8)
	actions.add_child(skill_row)
	target_row = HBoxContainer.new()
	target_row.add_theme_constant_override("separation", 8)
	actions.add_child(target_row)

	var center := CenterContainer.new()
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	result_panel = PanelContainer.new()
	result_panel.visible = false
	center.add_child(result_panel)
	var result_box := VBoxContainer.new()
	result_box.add_theme_constant_override("separation", 16)
	result_panel.add_child(result_box)
	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 40)
	result_box.add_child(result_label)
	var back := make_button("Về trang chính")
	back.pressed.connect(_on_back_pressed)
	result_box.add_child(back)

func make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(120, 44)
	button.focus_mode = Control.FOCUS_NONE # Tránh Enter/mũi tên vừa bấm nút vừa điều khiển bàn phím
	return button

func clear_row(row: HBoxContainer):
	for child in row.get_children():
		child.queue_free()

func refresh_actions():
	clear_row(skill_row)
	clear_row(target_row)
	var unit: UnitModel = battle_system.turn_controller.current_unit
	var selecting: bool = controller.state == SkillController.State.SELECT
	update_highlights(unit, controller.group_targets_select if selecting else [])
	if not selecting:
		return

	for i in unit.skills.size():
		var skill: SkillModel = unit.skills[i]
		var button := make_button("[%d] %s" % [i + 1, skill.name])
		button.tooltip_text = skill.base.description
		button.toggle_mode = true
		button.button_pressed = i == controller.current_index
		button.pressed.connect(controller.select_skill.bind(i, unit))
		skill_row.add_child(button)

	for i in controller.group_targets_available.size():
		var target: UnitModel = controller.group_targets_available[i]
		var button := make_button(target.name)
		button.toggle_mode = true
		button.button_pressed = target in controller.group_targets_select
		button.pressed.connect(controller.select_target.bind(i))
		target_row.add_child(button)

	var confirm := make_button("Xác nhận")
	confirm.pressed.connect(controller.confirm)
	target_row.add_child(confirm)

func update_highlights(active: UnitModel, targets: Array):
	for group in [battle_system.player_group, battle_system.enemy_group]:
		for child in group.get_children():
			if child is UnitNode3D:
				child.set_highlight(child.unit_model == active, child.unit_model in targets)

func add_log(line: String):
	log_lines.append(line)
	if log_lines.size() > MAX_LOG_LINES:
		log_lines.remove_at(0)
	log_label.text = "\n".join(log_lines)

func _on_turn_started(unit: UnitModel):
	turn_label.text = "Lượt của %s" % unit.name

func _on_turn_skipped(unit: UnitModel):
	if not unit.is_fainted:
		add_log("%s mất lượt" % unit.name)

func _on_damage_after(dm: DamageModel):
	var attacker: String = dm.source.name if dm.source != null else "Hiệu ứng"
	if dm.is_miss:
		add_log("%s đánh trượt %s" % [attacker, dm.target.name])
		return
	var line := "%s gây %d lên %s" % [attacker, dm.damage_dealt, dm.target.name]
	if dm.status != null:
		line += " (%s)" % dm.status.effect.name
	if dm.is_crit:
		line += " - Chí mạng"
	if dm.element_multiplier > 1.0:
		line += " - Khắc hệ"
	if dm.caused_break:
		line += " - BREAK"
	if dm.is_lethal:
		line += " - Hạ gục"
	add_log(line)

func _on_status_applied(unit: UnitModel, status: StatusModel):
	add_log("%s bị %s" % [unit.name, status.effect.name])

func _on_battle_ended(player_won: bool):
	clear_row(skill_row)
	clear_row(target_row)
	turn_label.text = ""
	result_label.text = "Chiến thắng" if player_won else "Thất bại"
	result_panel.visible = true

func _on_back_pressed():
	PlayerCollection.finish_battle()
	get_tree().change_scene_to_file(DEFAULT_SCENE)
