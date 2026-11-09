extends Passive

class_name PassiveLowHpBoost

# Tăng % sát thương khi máu còn thấp hơn ngưỡng
@export_range(0, 100) var hp_threshold: int = 33
@export_range(0, 300) var percent: int = 50

func on_before_deal_damage(unit: UnitModel, damage_model: DamageModel):
	if unit.health * 100 <= unit.max_health * hp_threshold:
		damage_model.set_damage(int(damage_model.get_damage() * (1.0 + percent / 100.0)))
