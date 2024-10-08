extends Node
class_name BattleSystem

@export var player: BattleUnit
@export var enemy: BattleUnit
@export var attackButton: Button

var player_creatures: Array = []:
  get:
    return [player]
var enemy_creatures: Array = []:
  get:
    return [enemy]
var turn_queue: Array = [] # Danh sách sắp xếp theo lượt đi
var current_index: int = 0 # Chỉ số lượt hiện tại

func _ready():
  print(SetDataBattleUnit())

func SetDataBattleUnit():
  if player == null or enemy == null:
    return false
  player.SetUp()
  enemy.SetUp()
  return true

func _on_button_attack_pressed() -> void:
  if player == null or enemy == null:
    return
  enemy.character.TakeDamage(null, player.character)
  player.hud.UpdateHP()
  enemy.hud.UpdateHP()
  # player.PrintCharacter()
  pass # Replace with function body.
