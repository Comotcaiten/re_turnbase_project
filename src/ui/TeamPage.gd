extends VBoxContainer

func refresh():
	var team: Array[OwnedUnit] = PlayerCollection.team
	%TeamLabel.text = "Đội hình: %d/%d" % [team.size(), PlayerCollection.MAX_TEAM_SIZE]

	for child in %TeamSlots.get_children():
		child.queue_free()
	for i in PlayerCollection.MAX_TEAM_SIZE:
		var unit: OwnedUnit = team[i] if i < team.size() else null
		var slot := UnitIcon.new()
		slot.setup(unit)
		if unit != null:
			slot.pressed.connect(_on_unit_pressed.bind(unit))
		%TeamSlots.add_child(slot)

	for child in %TeamGrid.get_children():
		child.queue_free()
	for unit in PlayerCollection.owned:
		var tile := UnitIcon.new()
		tile.setup(unit, PlayerCollection.is_in_team(unit))
		tile.pressed.connect(_on_unit_pressed.bind(unit))
		%TeamGrid.add_child(tile)

func _on_unit_pressed(unit: OwnedUnit):
	if PlayerCollection.is_in_team(unit):
		PlayerCollection.remove_from_team(unit)
	else:
		PlayerCollection.add_to_team(unit)
	refresh()
