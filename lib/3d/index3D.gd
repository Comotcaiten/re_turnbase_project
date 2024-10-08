extends Node

@export var player: BattleUnit

func _ready():
  set_up()
  pass

func _process(_delta: float):
  if Input.is_action_just_pressed("ui_skill_1"):
    print("[>] Action")
    player.RunAnimation3D("fight")
  if Input.is_action_just_pressed("ui_skill_2"):
    print("[>] Action")
    player.RunAnimation3D("fight2")
  if Input.is_action_just_pressed("ui_skill_3"):
    print("[>] Action")
    player.RunAnimation3D("fight3")
  if Input.is_action_just_pressed("ui_skill_4"):
    print("[>] Action")
    player.RunAnimation3D("fight5")
  pass

func set_up():
  player.SetUpOnlyCharacter()
  player.SetModel3D()
  print("[>] Player: ", player)
