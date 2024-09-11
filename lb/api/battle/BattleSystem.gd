extends Node
class_name BattleSystem

@export var player: BattleUnit

func _ready():
  print(SetDataBattleUnit())

func SetDataBattleUnit():
  print(player)
  print("-----")
  if player == null:
    return false
  player.SetUp()
  return true
