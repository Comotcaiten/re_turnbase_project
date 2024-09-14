extends Node
class_name BattleSystem

@export var player: BattleUnit

@export var attackButton: Button

func _ready():
  print(SetDataBattleUnit())

func SetDataBattleUnit():
  if player == null:
    return false
  player.SetUp()
  return true


func _on_button_attack_pressed() -> void:
  player.character.TakeDamage(null, player.character)
  player.hud.UpdateHP()
  # player.PrintCharacter()
  pass # Replace with function body.
