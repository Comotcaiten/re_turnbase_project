extends Passive

class_name PassiveThorns

# Phản lại % sát thương thực nhận, bỏ qua defense của kẻ tấn công
@export_range(0, 100) var percent: int = 30

func on_after_take_damage(unit: UnitModel, damage_model: DamageModel):
	var attacker: UnitModel = damage_model.source
	if attacker == null or attacker == unit or attacker.is_fainted:
		return
	var reflected := DamageModel.new(0, DamageModel.TypeDamage.DAMAGE, true, Element.Type.PHYSICAL, unit)
	reflected.from_passive = true
	reflected.set_damage(int(damage_model.damage_dealt * percent / 100.0))
	attacker.take_damage(reflected)
