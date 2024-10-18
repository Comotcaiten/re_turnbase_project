extends Node
class_name BattleSystemController

enum TypeState {CharacterTurn, ActionChoice, SkillChoice}

@export var player: BattleUnitModel

var unit_service: UnitService = UnitService.new()

var state: TypeState

var current_action: int:
  set(value):
    if value >= actions.size():
      current_action = current_action
    else:
      current_action = value
var actions = ["Attack", "Defense"]

var current_skill: int

func _ready():
  player.set_data()
  state = TypeState.CharacterTurn
  pass

func _process(_delta):
  match state:
    TypeState.CharacterTurn:
      perform_state_player()
    TypeState.ActionChoice:
      perform_state_action()
  pass

func perform_state_player():
  state = TypeState.ActionChoice

func perform_state_action():

  if Input.is_action_just_pressed("ui_skill_1"):
    current_action = 0
  if Input.is_action_just_pressed("ui_skill_2"):
    current_action = 1
  if Input.is_action_just_pressed("ui_skill_3"):
    current_action = 2
  if Input.is_action_just_pressed("ui_skill_4"):
    current_action = 3
  
  if Input.is_action_just_pressed("ui_accept"):
    perform_action_choice()

func perform_action_choice():
  print("[>] current_action: ", current_action)
  print("[>] actions: ", actions[current_action])

  state = TypeState.CharacterTurn
