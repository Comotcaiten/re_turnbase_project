extends SkillMechanic

class_name SkillMechanicHeal

# Hồi máu cho mục tiêu theo % máu tối đa của mục tiêu
@export_range(0, 100) var percent: int = 30

func apply_mechanic(_unit: UnitModel, targets: Array[UnitModel], _skill: SkillModel):
	for target in targets:
		target.heal(int(target.max_health * percent / 100.0))
