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
	sort_turn_queue()
	print(name, " >> TurnQueue: ", turn_queue)
	return true

func get_next_turn():
	# Bỏ qua unit đã gục, tối đa một vòng hàng đợi
	for i in turn_queue.size():
		current_index += 1
		if current_index >= turn_queue.size():
			current_index = 0
			sort_turn_queue() # Speed có thể đã đổi, vòng mới xếp lại
		if not current_unit.is_fainted:
			break
	print("Next turn: ", current_unit.name)
	return

# Speed cao đi trước, bằng speed thì giữ thứ tự nhóm
func sort_turn_queue():
	var order: Array[UnitModel] = battle_system.group_controller.get_all()
	turn_queue.sort_custom(func(a, b):
		if a.speed != b.speed:
			return a.speed > b.speed
		return order.find(a) < order.find(b)
	)
