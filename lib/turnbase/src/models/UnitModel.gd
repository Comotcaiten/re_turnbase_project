class_name UnitModel

var base: CharacterBase
var level: int:
    get:
        return max(0, level)
var skills: Array[SkillModel]

var attributes_base: Dictionary = base.attributes
var attributes_modified: Dictionary = {
    AttributeBase.Type.None: 0,
    AttributeBase.Type.Hp: 0,
    AttributeBase.Type.Attack: 0,
    AttributeBase.Type.Defense: 0,
    AttributeBase.Type.Speed: 0,
    AttributeBase.Type.Critical: 0,
    AttributeBase.Type.Others: 0
}

var hp: int
var mp: int

var max_hp: int:
    get:
        return get_attribute(AttributeBase.Type.Hp)
var max_mp: int:
    get:
        return get_attribute(AttributeBase.Type.Mp)
var attack: int:
    get:
        return get_attribute(AttributeBase.Type.Attack)
var defense: int:
    get:
        return get_attribute(AttributeBase.Type.Defense)
var speed: int:
    get:
        return get_attribute(AttributeBase.Type.Speed)
var critical: int:
    get:
        return get_attribute(AttributeBase.Type.Critical)

# <init>
func _init(_base: CharacterBase, _level: int) -> void:
    base = _base
    level = _level
# </init>

# <Get>
func get_attribute(_attribute):
    var amount_base = attributes_base[_attribute] * 1.0
    var amount_modified = attributes_modified[_attribute] * 1.0

    var amount_cal = amount_base + ((amount_base * amount_modified) / 100.0)

    return int(amount_cal)
# </Get>

# <Set>
func set_attribute_modified(_attribute: AttributeBase.Type, _amount: int):
    attributes_modified[_attribute] = _amount
# </Set>