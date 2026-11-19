extends CanvasLayer

# Battle UI Manager: dựng bố cục và nối sự kiện trận đấu vào từng khu vực HUD.
#
#   TopHUD            - kẻ địch đang chú ý (giữa) + AUTO / x2 / Tạm dừng (phải)
#   TurnOrderPanel    - thứ tự lượt (trái)
#   PlayerTeamPanel   - đội hình người chơi (dưới)
#   CombatActionPanel - skill + xác nhận (dưới phải)
#   BattleOverlay     - dấu mục tiêu, số sát thương (gắn theo World Space)
#   Toasts / Pause / Result
#
# UI chỉ phản ánh dữ liệu: thứ tự lượt lấy từ TurnController, lựa chọn lấy từ SkillController.

const DEFAULT_SCENE := "res://scene/default.tscn"
const MAX_TOASTS := 4
const TOAST_TIME := 2.4
const FAST_SPEED := 2.0

@export var battle_system: BattleSystem

var controller: SkillController
var overlay: BattleOverlay
var top_hud: TopHUD
var turn_order: TurnOrderPanel
var team_panel: PlayerTeamPanel
var action_panel: CombatActionPanel
var toast_box: VBoxContainer
var pause_layer: Control
var result_layer: Control
var result_label: Label

var is_ready: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # Nút Tạm dừng/Tiếp tục phải chạy khi cây bị pause
	controller = battle_system.skill_controller
	build_layout()
	# HUD _ready chạy trước BattleSystem._ready (cha), lúc đó đội hình chưa được tạo
	battle_system.ready.connect(_on_battle_ready, CONNECT_ONE_SHOT)

func _exit_tree():
	Engine.time_scale = 1.0
	if get_tree() != null:
		get_tree().paused = false

func _on_battle_ready():
	var nodes: Array[UnitNode3D] = []
	for group in [battle_system.player_group, battle_system.enemy_group]:
		for child in group.get_children():
			if child is UnitNode3D:
				nodes.append(child)
	overlay.register(nodes)
	team_panel.setup(battle_system.player_group.group)
	turn_order.setup(battle_system.turn_controller)
	action_panel.setup(controller)

	controller.selection_changed.connect(refresh_actions, CONNECT_DEFERRED)
	overlay.target_clicked.connect(controller.select_target)
	BattleEvents.turn_started.connect(_on_turn_started)
	BattleEvents.turn_skipped.connect(_on_turn_skipped)
	BattleEvents.damage_after.connect(_on_damage_after)
	BattleEvents.damage_after.connect(overlay._on_damage_after)
	BattleEvents.healed.connect(overlay._on_healed)
	BattleEvents.break_recovered.connect(_on_break_recovered)
	BattleEvents.status_applied.connect(_on_status_applied)
	BattleEvents.battle_ended.connect(_on_battle_ended)
	is_ready = true

# ---------------------------------------------------------
# Layout

func build_layout():
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Lớp World Space nằm dưới cùng để panel HUD luôn đè lên
	overlay = BattleOverlay.new()
	root.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	top_hud = TopHUD.new()
	root.add_child(top_hud)
	top_hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	top_hud.auto_toggled.connect(controller.set_auto_battle)
	top_hud.speed_toggled.connect(func(fast): Engine.time_scale = FAST_SPEED if fast else 1.0)
	top_hud.pause_pressed.connect(set_paused.bind(true))

	turn_order = TurnOrderPanel.new()
	root.add_child(turn_order)
	turn_order.position = Vector2(14, 14)

	team_panel = PlayerTeamPanel.new()
	root.add_child(team_panel)
	team_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	team_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	team_panel.offset_left = 180
	team_panel.offset_bottom = -12

	action_panel = CombatActionPanel.new()
	root.add_child(action_panel)
	action_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	action_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	action_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	action_panel.offset_right = -16
	action_panel.offset_bottom = -14

	toast_box = VBoxContainer.new()
	toast_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	toast_box.add_theme_constant_override("separation", 4)
	root.add_child(toast_box)
	# Cột thông báo góc phải, dưới nút điều khiển: không che đội hình ở giữa màn hình
	toast_box.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	toast_box.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	toast_box.offset_top = 62
	toast_box.offset_right = -12

	pause_layer = build_modal("Tạm dừng", [
		["Tiếp tục", set_paused.bind(false)],
		["Rời trận", _on_back_pressed],
	])
	root.add_child(pause_layer)

	result_layer = build_modal("", [["Về trang chính", _on_back_pressed]])
	result_label = result_layer.find_child("Title", true, false)
	root.add_child(result_layer)

# Lớp phủ tối toàn màn hình với tiêu đề và các nút ở giữa
func build_modal(title: String, buttons: Array) -> Control:
	var layer := ColorRect.new()
	layer.color = Color(0, 0, 0, 0.6)
	layer.visible = false
	layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	layer.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := HUDStyle.panel(HUDStyle.PANEL_LIGHT, 12, 28)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)
	var label := HUDStyle.label(title, 40)
	label.name = "Title"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(label)
	for entry in buttons:
		var button := Button.new()
		button.text = entry[0]
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(240, 46)
		button.add_theme_font_size_override("font_size", 18)
		button.pressed.connect(entry[1])
		box.add_child(button)
	return layer

# ---------------------------------------------------------
# Input

func _unhandled_input(event: InputEvent):
	if not is_ready or battle_system.is_game_over:
		return
	if event.is_action_pressed("ui_cancel"):
		set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()

func set_paused(value: bool):
	get_tree().paused = value
	pause_layer.visible = value

# ---------------------------------------------------------
# Refresh

func refresh_actions():
	if battle_system.is_game_over:
		return
	var unit: UnitModel = battle_system.turn_controller.current_unit
	var selecting: bool = controller.state == SkillController.State.SELECT
	var targets: Array = controller.group_targets_select if selecting else []

	action_panel.refresh(unit)
	team_panel.set_state(unit, targets)
	update_world_highlights(unit, targets)

	if selecting:
		var ally: bool = controller.current_skill != null and controller.current_skill.target_type != SkillBase.TargetType.ENEMY
		overlay.show_targets(controller.group_targets_available, targets, ally)
	else:
		overlay.clear_targets()
	top_hud.set_focus(pick_focus(unit, targets))

# Enemy Information bám theo Target Selection; lượt địch thì hiện địch đang hành động
func pick_focus(unit: UnitModel, targets: Array) -> UnitModel:
	for target in targets:
		if not target.is_player:
			return target
	if not unit.is_player:
		return unit
	if top_hud.focus != null and not top_hud.focus.is_fainted:
		return top_hud.focus
	var alive: Array = battle_system.enemy_group.get_filter_is_not_fainted()
	return alive[0] if not alive.is_empty() else null

func update_world_highlights(active: UnitModel, targets: Array):
	for group in [battle_system.player_group, battle_system.enemy_group]:
		for child in group.get_children():
			if child is UnitNode3D:
				child.set_highlight(child.unit_model == active, child.unit_model in targets)

func toast(text: String, color: Color = HUDStyle.TEXT):
	var panel := HUDStyle.panel(HUDStyle.PANEL, 14, 6)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_END
	var label := HUDStyle.label(text, 15, color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(label)
	toast_box.add_child(panel)
	while toast_box.get_child_count() > MAX_TOASTS:
		var old: Node = toast_box.get_child(0)
		toast_box.remove_child(old)
		old.queue_free()
	var tween := panel.create_tween()
	tween.tween_interval(TOAST_TIME)
	tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	tween.tween_callback(panel.queue_free)

# ---------------------------------------------------------
# Events

func _on_turn_started(unit: UnitModel):
	turn_order.refresh()
	toast("Lượt của %s" % unit.name, HUDStyle.ACCENT if unit.is_player else HUDStyle.HP_ENEMY)
	refresh_actions()

func _on_turn_skipped(unit: UnitModel):
	turn_order.refresh()
	if not unit.is_fainted:
		toast("%s mất lượt" % unit.name, HUDStyle.TEXT_DIM)

func _on_damage_after(dm: DamageModel):
	turn_order.refresh() # Gục hoặc bị break làm đổi thứ tự lượt
	if dm.is_lethal and not dm.is_miss:
		toast("%s bị hạ gục" % dm.target.name, HUDStyle.TARGET)
	elif dm.caused_break:
		toast("%s bị BREAK - mất lượt kế tiếp" % dm.target.name, HUDStyle.BROKEN)

func _on_break_recovered(unit: UnitModel):
	turn_order.refresh()
	toast("%s hồi phục break" % unit.name, HUDStyle.TEXT_DIM)

func _on_status_applied(unit: UnitModel, status: StatusModel):
	toast("%s bị %s" % [unit.name, status.effect.name], Color(0.85, 0.65, 1.0))

func _on_battle_ended(player_won: bool):
	overlay.clear_targets()
	action_panel.visible = false
	Engine.time_scale = 1.0
	result_label.text = "Chiến thắng" if player_won else "Thất bại"
	result_label.add_theme_color_override("font_color", HUDStyle.CRIT if player_won else HUDStyle.TARGET)
	result_layer.visible = true

func _on_back_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	PlayerCollection.finish_battle()
	get_tree().change_scene_to_file(DEFAULT_SCENE)
