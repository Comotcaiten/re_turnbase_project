extends Passive

class_name PassiveContactStatus

# Khi bị đánh, có tỉ lệ gây hiệu ứng lên kẻ tấn công
@export var status: StatusEffect
@export_range(0, 100) var chance: int = 30

func on_after_take_damage(unit: UnitModel, damage_model: DamageModel):
	var attacker: UnitModel = damage_model.source
	if attacker == null or attacker == unit or attacker.is_fainted:
		return
	if randi_range(1, 100) <= chance:
		attacker.apply_status(status, unit)
