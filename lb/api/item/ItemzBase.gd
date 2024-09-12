extends Resource
class_name ItemzBase

@export_group("Icon")
@export var icon: Texture2D

@export_group("Text")
@export var id: String
@export var name: String

@export_group("Extras")
@export var damage: int
@export var unbreakable: bool

@export_group("Attributes")
@export var attributes: Array[ItemzAttribute] = []

@export_group("Rule")
@export var maxAmount: int:
  get:
    return max(maxAmount, 0)

func GetValueAttribute(_attribute: CharacterBase.Attribute) -> int:
  for attr in attributes:
      if attr.type == _attribute:
          return attr.values
  return 0 # Default value if no matching attribute is found