extends Resource
class_name ItemBase

@export var name: String

@export_group("Extras")
@export var unbreakable: bool
@export var damage: int:
  get:
    return max(0, damage)

# @export_group("Food")
# @export var nutrition: int:
#   get:
#     return max(0, nutrition)
# @export var staturation: int:
#   get:
#     return max(0, staturation)
# @export var can_always_eat: bool

# @export_group("Enchantments")