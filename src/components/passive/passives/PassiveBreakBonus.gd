extends Passive

class_name PassiveBreakBonus

# Tăng % sát thương lên mục tiêu đang bị break
@export_range(0, 300) var percent: int = 30

func on_before_deal_damage(_unit: UnitModel, damage_model: DamageModel):
	if damage_model.target.is_broken:
		damage_model.set_damage(int(damage_model.get_damage() * (1.0 + percent / 100.0)))
