extends SkillMechanic
class_name DamageMechanic

enum TypeDamage {Damage, Multiplier, PercentLeft, PercentMising}

@export var damageType: TypeDamage = TypeDamage.Damage
@export var power: int
@export var trueDamage: bool

func Apply(_source: Character, _target: Character, _skill: Skill) -> bool:
	# Áp dụng sát thương
	var dmg = CalculatorDamaged(_source, _target, _skill)
	print("[>] ", _target.nameCharacter, " take ", dmg, " DMG")
	_target.hp -= dmg
	
	# Kiểm tra nếu mục tiêu bị hạ gục
	return _target.hp <= 0

func CalculatorDamaged(_source: Character, _target: Character, _skill: Skill) -> int:
	if (_source == null) or (_target == null) or (_skill == null):
		return 0
	
	var critical = 1.0
	var typeEff = 1.0

	if _skill != null:
		typeEff = ElementEffectiveness.GetEffectiveness(_skill.base.element, _target.element)
	else:
		typeEff = ElementEffectiveness.GetEffectiveness(_source.element, _target.element)
	
	var attacker_damage = _source.attack
	if _source.mainHand != null:
		attacker_damage += _source.mainHand.damage
		
	# Nếu trueDamage, bỏ qua phòng thủ
	var target_defense = _target.defense
	if trueDamage:
		target_defense = 0

	# Sử dụng match để xử lý theo loại sát thương
	var damage = 0
	match damageType:
		TypeDamage.Damage:
			# Sát thương cơ bản
			var a = (2.0 * attacker_damage + 10.0) * typeEff * critical * randf_range(0.85, 1.0)
			damage = ((a / (target_defense * 1.0))) + 2.0
		
		TypeDamage.Multiplier:
			# Nhân với sức mạnh (power)
			var a = (2.0 * attacker_damage + 10.0) * typeEff * critical * randf_range(0.85, 1.0)
			damage = ((a / (target_defense * 1.0))) * power + 2.0
		
		TypeDamage.PercentLeft:
			# Gây sát thương dựa trên % máu còn lại của mục tiêu
			damage = power * (_target.hp / 100.0)
		
		TypeDamage.PercentMising:
			# Gây sát thương dựa trên % máu đã mất của mục tiêu
			var missing_hp = _target.max_hp - _target.hp
			damage = missing_hp * (power / 100.0)

	return max(0, int(damage))  # Đảm bảo sát thương không âm