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

@export_group("Attributes")
# @export_group("Food")
# @export var nutrition: int:
#   get:
#     return max(0, nutrition)
# @export var staturation: int:
#   get:
#     return max(0, staturation)
# @export var can_always_eat: bool

# @export_group("Enchantments")