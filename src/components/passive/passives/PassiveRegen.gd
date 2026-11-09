extends Passive

class_name PassiveRegen

# Hồi máu theo % máu tối đa vào đầu mỗi lượt
@export_range(0, 100) var percent: int = 10

func on_turn_start(unit: UnitModel):
	unit.heal(int(unit.max_health * percent / 100.0))
