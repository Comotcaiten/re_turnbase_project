extends Resource
class_name ItemzBase

@export var id: String
@export var name: String
@export var icon: Texture2D

@export var damage: int
@export var unbreakable: bool

@export var attributes: Array[ItemzAttribute]