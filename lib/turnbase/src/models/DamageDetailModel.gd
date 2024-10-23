class_name DamageDetailModel

var damage: int
var element: ElementBase.Type
var true_damage: bool
var source: UnitModel

var dynamic

func _init(_damage: int, _element: ElementBase.Type, _true_damage: bool, _source: UnitModel ,_dynamic):
  damage = _damage
  element = _element
  true_damage = _true_damage
  source = _source
  dynamic = _dynamic
  pass