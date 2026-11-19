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


# Dự đoán count lượt kế tiếp (bắt đầu từ unit hiện tại) cho Turn Order HUD.
# Mô phỏng y hệt get_next_turn(): bỏ unit đã gục, hết vòng thì xếp lại theo speed.
func get_preview(count: int) -> Array[UnitModel]:
	var preview: Array[UnitModel] = []
	if turn_queue.is_empty():
		return preview
	var queue: Array[UnitModel] = turn_queue.duplicate()
	var index: int = current_index
	var alive: int = queue.filter(func(x): return not x.is_fainted).size()
	if alive == 0:
		return preview
	var order: Array[UnitModel] = battle_system.group_controller.get_all()
	var guard: int = count * (queue.size() + 1)
	while preview.size() < count and guard > 0:
		guard -= 1
		var unit: UnitModel = queue[index]
		if not unit.is_fainted:
			preview.append(unit)
		index += 1
		if index >= queue.size():
			index = 0
			queue.sort_custom(func(a, b):
				if a.speed != b.speed:
					return a.speed > b.speed
				return order.find(a) < order.find(b)
			)
	return preview
