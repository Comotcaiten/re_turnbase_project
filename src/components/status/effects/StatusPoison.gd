extends StatusEffect

class_name StatusPoison

# Mất % máu tối đa vào đầu mỗi lượt
@export_range(0, 100) var percent: int = 10

func _init():
	name = "Độc"
	duration = 3

func on_turn_start(unit: UnitModel, status: StatusModel):
	unit.take_status_damage(int(unit.max_health * percent / 100.0), status)
