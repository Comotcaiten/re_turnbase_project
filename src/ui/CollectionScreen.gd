extends Control

const BATTLE_SCENE := "res://test/level_testing.tscn"

var list: VBoxContainer
var team_label: Label
var start_button: Button

func _ready():
	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 32)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)

	var title := Label.new()
	title.text = "Bộ sưu tập"
	title.add_theme_font_size_override("font_size", 32)
	root.add_child(title)

	team_label = Label.new()
	root.add_child(team_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	list = VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 8)
	scroll.add_child(list)

	start_button = Button.new()
	start_button.text = "Vào trận"
	start_button.pressed.connect(_on_start_pressed)
	root.add_child(start_button)

	refresh()

func refresh():
	for child in list.get_children():
		child.queue_free()
	for unit in PlayerCollection.owned:
		list.add_child(create_row(unit))

	var team_size: int = PlayerCollection.team.size()
	team_label.text = "Đội hình: %d/%d" % [team_size, PlayerCollection.MAX_TEAM_SIZE]
	start_button.disabled = team_size == 0

func create_row(unit: OwnedUnit) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var info := Label.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.text = "%s  |  %s  |  %s  |  Lv.%d" % [
		unit.base.name,
		Role.get_display_name(unit.base.role),
		Element.Type.keys()[unit.base.element],
		unit.level,
	]
	row.add_child(info)

	var level_button := Button.new()
	level_button.text = "Lên cấp"
	level_button.disabled = unit.level >= OwnedUnit.MAX_LEVEL
	level_button.pressed.connect(_on_level_up_pressed.bind(unit))
	row.add_child(level_button)

	var in_team: bool = PlayerCollection.is_in_team(unit)
	var team_button := Button.new()
	team_button.text = "Rời đội" if in_team else "Vào đội"
	team_button.disabled = not in_team and PlayerCollection.team.size() >= PlayerCollection.MAX_TEAM_SIZE
	team_button.pressed.connect(_on_team_pressed.bind(unit))
	row.add_child(team_button)
	return row

func _on_level_up_pressed(unit: OwnedUnit):
	PlayerCollection.level_up(unit)
	refresh()

func _on_team_pressed(unit: OwnedUnit):
	if PlayerCollection.is_in_team(unit):
		PlayerCollection.remove_from_team(unit)
	else:
		PlayerCollection.add_to_team(unit)
	refresh()

func _on_start_pressed():
	PlayerCollection.prepare_battle()
	get_tree().change_scene_to_file(BATTLE_SCENE)
