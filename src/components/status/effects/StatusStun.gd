extends StatusEffect

class_name StatusStun

# Mất lượt, và/hoặc giảm chính xác và crit
@export var lose_turn: bool = true
@export_range(0, 100) var accuracy_penalty: int = 0
@export_range(0, 100) var crit_penalty: int = 0

func _init():
	name = "Choáng"
	duration = 1

func prevents_action(_status: StatusModel) -> bool:
	return lose_turn

func get_accuracy_bonus(_status: StatusModel) -> int:
	return -accuracy_penalty

func get_crit_bonus(_status: StatusModel) -> int:
	return -crit_penalty
