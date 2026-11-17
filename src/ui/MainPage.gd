extends CenterContainer

const BATTLE_SCENE := "res://scene/battle.tscn"

func _ready():
	%StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	PlayerCollection.prepare_battle()
	get_tree().change_scene_to_file(BATTLE_SCENE)
