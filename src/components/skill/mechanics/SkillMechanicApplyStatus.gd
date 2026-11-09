extends SkillMechanic

class_name SkillMechanicApplyStatus

@export var status: StatusEffect
@export_range(0, 100) var chance: int = 100
@export var apply_to_self: bool = false # Áp lên người dùng skill thay vì mục tiêu

func apply_mechanic(unit: UnitModel, targets: Array[UnitModel], _skill: SkillModel):
	var receivers: Array[UnitModel] = targets
	if apply_to_self:
		receivers = [unit]
	for receiver in receivers:
		if randi_range(1, 100) <= chance:
			receiver.apply_status(status, unit)
