extends Node

@export var player: BattleUnit
@export var enemy: BattleUnit

var play_at_first: bool = true

func _ready():
  set_up()
  pass

func _process(_delta: float):

  if play_at_first:
    player.RunAnimation3D('idle')
    enemy.RunAnimation3D('idle')
    play_at_first = false
  
  if Input.is_action_just_pressed("ui_skill_1"):
    print("[>] Action")
    player.RunAnimation3D("fight")
    enemy.RunAnimation3D("fight")
  elif Input.is_action_just_pressed("ui_skill_2"):
    print("[>] Action")
    player.RunAnimation3D("fight2")
    enemy.RunAnimation3D("fight")
  elif Input.is_action_just_pressed("ui_skill_3"):
    print("[>] Action")
    player.RunAnimation3D("fight3")
    enemy.RunAnimation3D("fight")
  elif Input.is_action_just_pressed("ui_skill_4"):
    print("[>] Action")
    player.RunAnimation3D("fight4")
    enemy.RunAnimation3D("fight")
  pass

func set_up():
  player.SetUpOnlyCharacter()
  player.SetModel3D()

  enemy.SetUpOnlyCharacter()
  enemy.SetModel3D()

  for unit in [player, enemy]:
    is_player_unit_set_up(unit)
  print("[>] Player: ", player)

func is_player_unit_set_up(_unit: BattleUnit):
  if !_unit.isPlayerUnit:
    _unit.rotation.y = deg_to_rad(180)