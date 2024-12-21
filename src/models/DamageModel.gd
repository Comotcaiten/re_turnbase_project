extends Resource
class_name DamageModel

# Enumerations for kind and type
enum TypeDamage {Damage, Multiplier, PercentLeft, PercentMissing}
enum TypeAttack {Physical, Magic}

# Properties
@export var power: int = 0 # Tăng sát thương n
@export var type_attack: TypeAttack = TypeAttack.Physical # Kiểu tấn công mặc định
@export var type_damage: TypeDamage = TypeDamage.Damage # Kiểu thiệt hại mặc định
@export var true_damage: bool = false # Mặc định không bỏ qua phòng thủ
@export var element: CharacterBase.Element # Nguyên tố

# Variables
var source: UnitModel = null
var damage: int = 0

# Constructor
func _init(_damage_model: DamageModel = null):
    if _damage_model != null:
        power = _damage_model.power
        type_attack = _damage_model.type_attack
        type_damage = _damage_model.type_damage
        true_damage = _damage_model.true_damage
        element = _damage_model.element
        source = _damage_model.source
    else:
        power = 0
        type_attack = TypeAttack.Physical
        type_damage = TypeDamage.Damage
        true_damage = false

# Method to set damage
func set_damage(_val: int = 0):
    damage = _val
