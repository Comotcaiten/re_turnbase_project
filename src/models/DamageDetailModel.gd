class_name DamageDetailModel

enum TypeAttack {Physical, Magic}

var damage_amount: int
var type_attack: TypeAttack
var true_damage: bool
var element: CharacterBase.Element
var source: UnitModel

func _init(_amount: int, _type: TypeAttack, _true_damage: bool, _element: CharacterBase.Element, _source: UnitModel):
  damage_amount = _amount
  type_attack = _type
  true_damage = _true_damage
  element = _element
  source = _source
  pass