class_name DamageModel

enum TypeDamage {DAMAGE, MULTIPLIER, PERCENTLEFT, PERCENTMISSING}
# enum TypeAttack {Physical, Magic}

# Properties
var power: int = 0 # Tăng sát thương n
var type_damage: TypeDamage = TypeDamage.DAMAGE # Kiểu thiệt hại mặc định
var true_damage: bool = false # Mặc định không bỏ qua phòng thủ

var element: Element.Type

var damage: int = 0

var source: UnitModel = null

func _init(_power: int = 0, _type_damage: TypeDamage = TypeDamage.DAMAGE, _true_damage: bool = false, _element: Element.Type = Element.Type.PHYSICAL, _source: UnitModel = null):
  power = _power
  type_damage = _type_damage
  true_damage = _true_damage
  element = _element
  source = _source
  return

func set_damage(_damage: int):
  damage = max(1, _damage)
  return

func get_damage() -> int:
  return max(1, damage)