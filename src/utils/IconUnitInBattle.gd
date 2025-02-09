extends Node

class_name IconUnitInBattle

@export var icon: Sprite2D = null

@export var sprite_container: Sprite2D = null

func _ready():
  sprite_container.visible = false
  pass