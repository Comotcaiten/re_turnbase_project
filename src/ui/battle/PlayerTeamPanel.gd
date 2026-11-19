extends HBoxContainer

class_name PlayerTeamPanel

# Bottom HUD: các ô nhân vật phe người chơi.

var slots: Array[CharacterSlot] = []

func setup(units: Array[UnitModel]):
	add_theme_constant_override("separation", 10)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	HUDStyle.clear(self)
	slots.clear()
	for unit in units:
		var slot := CharacterSlot.new()
		add_child(slot)
		slot.setup(unit)
		slots.append(slot)

func set_state(active: UnitModel, targets: Array):
	for slot in slots:
		slot.set_state(slot.unit == active, slot.unit in targets)
