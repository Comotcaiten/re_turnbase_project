extends StatusEffect

class_name StatusClarity

# Tăng tỉ lệ crit
@export_range(0, 100) var crit_bonus: int = 30

func _init():
	name = "Minh mẫn"
	duration = 3

func get_crit_bonus(_status: StatusModel) -> int:
	return crit_bonus
