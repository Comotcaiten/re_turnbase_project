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
@export var attributes: Array[ItemzAttribute]