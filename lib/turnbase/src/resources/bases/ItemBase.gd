extends Resource
class_name ItemBase

@export var name: String
@export var description: String # Thêm mô tả cho vật phẩm
@export var rarity: String # Thêm độ hiếm cho vật phẩm (Common, Rare, Legendary)

@export_group("Extras")
@export var unbreakable: bool
@export var damage: int:
  get:
    return max(0, damage)

@export_group("Attributes Bonus")
@export var hp: int
@export var mp: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var crit: int

var attributes: Dictionary:
    get:
        return {
            AttributeBase.Type.None: 0,
            AttributeBase.Type.Hp: hp,
            AttributeBase.Type.Mp: mp,
            AttributeBase.Type.Attack: attack,
            AttributeBase.Type.Defense: defense,
            AttributeBase.Type.Speed: speed,
            AttributeBase.Type.Critical: crit,
            AttributeBase.Type.Others: 0
        }

# @export_group("Food")
# @export var nutrition: int:
#   get:
#     return max(0, nutrition)
# @export var staturation: int:
#   get:
#     return max(0, staturation)
# @export var can_always_eat: bool

# @export_group("Enchantments")