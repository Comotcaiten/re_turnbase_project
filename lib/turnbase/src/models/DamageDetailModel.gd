class_name DamageDetailModel

var damage: int
var element: ElementBase.Type
var is_critical: bool

var dynamic

func _init(_damage: int, _element: ElementBase.Type, _is_critical: bool, _dynamic):
  damage = _damage
  element = _element
  is_critical = _is_critical
  dynamic = _dynamic
  pass