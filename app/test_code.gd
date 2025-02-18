extends Node2D

@export var player_data: PlayerDB

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player_data.id)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
