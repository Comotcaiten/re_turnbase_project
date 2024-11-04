class_name DamageDetailModel

var source: UnitModel
var damage: int
var true_damage: int
var dynamic

# <Init>
func _init(_source: UnitModel, _damage: int, _true_damage: bool):
    source = _source
    damage = _damage
    true_damage = _true_damage
    pass
# </Init>

func set_dynamic(_dynamic):
    dynamic = _dynamic
    pass