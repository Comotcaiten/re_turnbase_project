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
	turn_queue = battle_system.group_controller.get_all()
	print(name, " >> TurnQueue: ", turn_queue)
	return true

func get_next_turn():
	current_index += 1
	if current_index >= turn_queue.size():
		current_index = 0
	print("Next turn: ", current_unit.name)
	return
