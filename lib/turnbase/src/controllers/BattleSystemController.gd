extends Node
class_name BattleSystemController

enum TypeState {CharacterTurn, ActionChoice, SkillChoice}

@export var player: BattleUnitModel

var state: TypeState

var current_action: int
var actions = ["Attack", "Defense"]

var current_skill: int

func _ready():
  pass