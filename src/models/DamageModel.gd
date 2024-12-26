class_name DamageModel

# Enumerations for kind and type
enum TypeDamage {Damage, Multiplier, PercentLeft, PercentMissing}
enum TypeAttack {Physical, Magic}

# Properties
var power: int = 0 # Tăng sát thương n
var type_attack: TypeAttack = TypeAttack.Physical # Kiểu tấn công mặc định
var type_damage: TypeDamage = TypeDamage.Damage # Kiểu thiệt hại mặc định
var true_damage: bool = false # Mặc định không bỏ qua phòng thủ
var element: CharacterBase.Element # Nguyên tố

var source: UnitModel
var target: UnitModel
var modifi: int = 1
# Constructor
func _init(_power: int = 0, _type_attack: TypeAttack = TypeAttack.Physical, _type_damage: TypeDamage = TypeDamage.Damage, _true_damage: bool = false, _element: CharacterBase.Element = CharacterBase.Element):
	power = _power
	type_attack = _type_attack
	type_damage = _type_damage
	true_damage = _true_damage
	element = _element

func set_calculate_damage(_target: UnitModel = null, _source: UnitModel = null, _modifi: int = 1) -> bool:
	if _target == null or _source == null:
		return false
	source = _source
	target = _target
	modifi = _modifi
	return true

func set_source(_source: UnitModel = null) -> bool:
	if _source == null:
		return false
	source = _source
	return true

func set_target(_target: UnitModel = null) -> bool:
	if _target == null:
		return false
	target = _target
	return true

func set_modifi(_modifi: int = 1) -> bool:
	modifi = _modifi
	return true

func calculate_damage() -> int:
	if source == null or target == null:
		return 0
	var attack_power: float = 1.0
	var random_factor = randf_range(0.85, 1.0)
	match type_attack:
		TypeAttack.Physical:
			attack_power = source.get_stat(CharacterBase.StatType.AttackPhysical) * 1.0
		TypeAttack.Magic:
			attack_power = source.get_stat(CharacterBase.StatType.AttackMagic) * 1.0
		_:
			attack_power = 1.0
	match type_damage:
		DamageModel.TypeDamage.Damage:
			# Sát thương cơ bản
			attack_power = ((2.0 * (attack_power * 1.0) + 10.0 + power) * random_factor)
		DamageModel.TypeDamage.Multiplier:
			# Nhân với sức mạnh (power)
			attack_power = ((2.0 * (attack_power * 1.0) * power + 10.0) * random_factor)
		DamageModel.TypeDamage.PercentLeft:
			attack_power = (power * ((target.health * 1.0) / 100.0))
		DamageModel.TypeDamage.PercentMissing:
			var missing_hp = target.max_health - target.health
			attack_power = (missing_hp * (power / 100.0))
	return int(attack_power * (modifi * 1.0))