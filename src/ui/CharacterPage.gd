extends HBoxContainer

const SLOT_SIZE := Vector2(90, 48)
const ITEM_SIZE := Vector2(190, 48)

var selected: OwnedUnit = null

func _ready():
	%LevelUpButton.pressed.connect(_on_level_up_pressed)

func refresh():
	for child in %CharacterGrid.get_children():
		child.queue_free()
	if selected == null and not PlayerCollection.owned.is_empty():
		selected = PlayerCollection.owned[0]
	for unit in PlayerCollection.owned:
		var tile := UnitIcon.new()
		tile.setup(unit, unit == selected)
		tile.pressed.connect(_on_tile_pressed.bind(unit))
		%CharacterGrid.add_child(tile)
	show_detail()

func show_detail():
	%DetailPanel.visible = selected != null
	if selected == null:
		return
	var base: UnitBase = selected.base
	var model: UnitModel = selected.to_unit_model()

	for child in %DetailIcon.get_children():
		child.queue_free()
	var icon := UnitIcon.new()
	icon.setup(selected)
	%DetailIcon.add_child(icon)

	%DetailName.text = base.name
	%DetailInfo.text = "%s  |  Hệ %s  |  Lv.%d" % [Role.get_display_name(base.role), Element.get_display_name(base.element), selected.level]
	%DetailDescription.text = base.description
	%DetailStats.text = "HP %d    MP %d    Break %d\nTấn công %d    Phòng thủ %d    Tốc độ %d\nChí mạng %d%%    Chính xác %d%%" % [
		model.max_health, model.max_mp, model.max_break,
		model.attack, model.defense, model.speed,
		base.crit_chance, base.accuracy,
	]

	var lines: PackedStringArray = []
	for skill in base.skills:
		lines.append("%s (%s): %s" % [skill.name, Element.get_display_name(skill.element), skill.description])
	if base.passive != null:
		lines.append("Nội tại - %s: %s" % [base.passive.name, base.passive.description])
	%DetailSkills.text = "\n".join(lines)

	%LevelUpButton.disabled = selected.level >= OwnedUnit.MAX_LEVEL
	show_items()

func show_items():
	%ItemLabel.text = "Trang bị: %d/%d ô  |  Cost %d/%d  (bấm ô để tháo, bấm item bên dưới để đeo)" % [
		selected.items.size(), UnitModel.MAX_ITEM_SLOTS,
		selected.get_item_cost(), UnitModel.MAX_ITEM_COST,
	]

	for child in %EquippedRow.get_children():
		child.queue_free()
	for i in UnitModel.MAX_ITEM_SLOTS:
		var item: ItemBase = selected.items[i] if i < selected.items.size() else null
		var slot := make_item_button("+" if item == null else "%s\n[%d]" % [item.name, item.cost], SLOT_SIZE)
		if item == null:
			slot.disabled = true
		else:
			slot.tooltip_text = get_item_tooltip(item)
			slot.pressed.connect(_on_slot_pressed.bind(i))
		%EquippedRow.add_child(slot)

	for child in %ItemGrid.get_children():
		child.queue_free()
	for item in PlayerCollection.item_catalog:
		var button := make_item_button("%s [%d]\n%s" % [item.name, item.cost, item.get_summary()], ITEM_SIZE)
		button.tooltip_text = get_item_tooltip(item)
		button.disabled = not selected.can_equip(item)
		button.pressed.connect(_on_item_pressed.bind(item))
		%ItemGrid.add_child(button)

func make_item_button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 12)
	return button

func get_item_tooltip(item: ItemBase) -> String:
	var lines: PackedStringArray = ["%s (cost %d)" % [item.name, item.cost], item.get_summary()]
	for passive in item.passives:
		lines.append("%s: %s" % [passive.name, passive.description])
	return "\n".join(lines)

func _on_slot_pressed(index: int):
	PlayerCollection.unequip_item_at(selected, index)
	refresh()

func _on_item_pressed(item: ItemBase):
	PlayerCollection.equip_item(selected, item)
	refresh()

func _on_tile_pressed(unit: OwnedUnit):
	selected = unit
	refresh()

func _on_level_up_pressed():
	PlayerCollection.level_up(selected)
	refresh()
