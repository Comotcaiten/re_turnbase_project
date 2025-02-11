### TurnController.gd
extends Node

class_name TurnController


var turn_queue: Array[UnitModel] = []
var current_index: int = 0

var current_unit: UnitModel:
	get:
		return turn_queue[current_index]
	
var battle_system: BattleSystem

func initialized(_battle_system: BattleSystem):
	battle_system = _battle_system
	pass

func set_up():
	if battle_system == null:
		return false
	if battle_system.group_controller == null:
		return false
	update()
	
	print(name, " >> TurnQueue: ", get_to_string())
	return true

func get_next_turn():
	current_index += 1
	if current_index >= turn_queue.size():
		current_index = 0
	update_simple()
	print("Next turn: ", current_unit.name)
	return

func update() -> bool:
	if battle_system == null:
		return false
	if battle_system.group_controller == null:
		return false
	if battle_system.group_controller.get_all_units().size() == 0:
		return false
	# if battle_system.group_controller.get_all_units().size() != turn_queue.size():
	turn_queue = battle_system.group_controller.get_all_units().filter(func(unit):
		return unit.is_fainted == false
		)
	turn_queue.sort_custom(func(a, b):
		return a.speed > b.speed
		)
	return true

func update_simple() -> bool:
	if battle_system == null:
		return false
	var group: Array[UnitModel] = battle_system.group_controller.get_all_units().filter(func(unit):
		return unit.is_fainted == false
		)
	if (turn_queue.size() == 0) and (turn_queue.size() != group.size()):
		return false

	turn_queue = group

	turn_queue.sort_custom(func(a, b):
		return a.speed > b.speed
		)
	return true

func get_to_string():
	var context: String = ""
	for unit in turn_queue:
		context += unit.to_string() + " [" + str(unit.speed) + "]" + ", "
	return context