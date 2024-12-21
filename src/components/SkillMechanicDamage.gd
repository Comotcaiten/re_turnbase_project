extends SkillMechanic
class_name SkillMechanicDamage

# Damage Model instance
@export var damage_model: DamageModel

var source: UnitModel
# Apply mechanic
func apply_mechanic(_targets: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
	if _targets == [] or _source == null or _skill == null or _battle_system == null or damage_model == null:
		return false
	# Set the source for damage calculations
	damage_model.source = _source
	source = source

	match _skill.target_mode:
		SkillBase.TargetMode.THREE:
			for target in _targets:
				var new_damage_model: DamageModel = DamageModel.new(damage_model)
				if target == _battle_system.skill_sytem_controller.current_target_unit:
					new_damage_model.damage = calculate_damage(target, 1.0)
				else:
					new_damage_model.damage = calculate_damage(target, 0.5)
				target.get_damage(new_damage_model)
		_:
			for target in _targets:
				var new_damage_model: DamageModel = DamageModel.new(damage_model)
				new_damage_model.damage = calculate_damage(target, 1.0)
				target.get_damage(new_damage_model)
	return true

# Calculate damage for a specific target
func calculate_damage(_target: UnitModel, _modifi: float = 1) -> int:
	if _target == null or damage_model == null or source == null:
		return 1
	
	var critical: int = damage_model.true_damage and 2 or 1
	var attack: int = 1
	var power: int = damage_model.power
	var damage: float = 0.0

	match damage_model.type_attack:
		DamageModel.TypeAttack.Physical:
			attack = max(1, source.attack_physical)
		DamageModel.TypeAttack.Magic:
			attack = max(1, source.attack_magic)

	match damage_model.type_damage:
		DamageModel.TypeDamage.Damage:
			# Sát thương cơ bản
			damage = (2.0 * (attack * 1.0) + 10.0 + power) * critical * randf_range(0.85, 1.0)
		DamageModel.TypeDamage.Multiplier:
			# Nhân với sức mạnh (power)
			damage = (2.0 * (attack * 1.0) * power + 10.0) * critical * randf_range(0.85, 1.0)
		DamageModel.TypeDamage.PercentLeft:
			# Gây sát thương dựa trên % máu còn lại của mục tiêu
			damage = power * ((_target.stats_controller.health * 1.0) / 100.0)
		DamageModel.TypeDamage.PercentMissing:
			# Gây sát thương dựa trên % máu đã mất của mục tiêu
			var missing_hp = _target.max_hp - _target.hp
			damage = missing_hp * (power / 100.0)
	return int(damage * (_modifi * 1.0))

func damage_target_type_three():
	return