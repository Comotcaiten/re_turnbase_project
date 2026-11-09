extends Resource

class_name StatusEffect

# Kế thừa class này và ghi đè hook cần dùng.
# Trạng thái riêng của từng unit (số lượt, stack) nằm trong StatusModel.
@export var name: String
@export var duration: int = 3 # Số lần bắt đầu lượt mà hiệu ứng còn tác dụng
@export var max_stacks: int = 1

func on_turn_start(_unit: UnitModel, _status: StatusModel):
	pass

func prevents_action(_status: StatusModel) -> bool:
	return false

func get_crit_bonus(_status: StatusModel) -> int:
	return 0

func get_accuracy_bonus(_status: StatusModel) -> int:
	return 0
