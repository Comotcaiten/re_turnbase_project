extends Passive

class_name PassiveLifesteal

# Hồi máu theo % sát thương thực gây ra
@export_range(0, 100) var percent: int = 20

func on_after_deal_damage(unit: UnitModel, damage_model: DamageModel):
	unit.heal(int(damage_model.damage_dealt * percent / 100.0))
