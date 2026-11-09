extends StatusEffect

class_name StatusBleed

# Đầu mỗi lượt mất máu theo % ATK của người gây, nhân số stack
@export_range(0, 300) var percent: int = 100

func _init():
	name = "Chảy máu"
	duration = 3
	max_stacks = 3

func on_turn_start(unit: UnitModel, status: StatusModel):
	unit.take_status_damage(int(status.source_attack * percent / 100.0) * status.stacks, status)
