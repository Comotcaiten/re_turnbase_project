class_name DamageDetailModel

var damage: int
var element: ElementBase.Type
var true_damage: bool

var dynamic

func _init(_damage: int, _element: ElementBase.Type, _true_damage: bool, _dynamic):
  damage = _damage
  element = _element
  true_damage = _true_damage
  dynamic = _dynamic
  pass