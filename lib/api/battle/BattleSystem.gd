extends Node
class_name BattleSystem

@export var player: BattleUnit
@export var enemy: BattleUnit
# @export var attackButton: Button

enum TypeState {CharacterTurn, ActionChoice, SkillChoice}

var state: TypeState

var current_action: int
var actions = ["Attack", "Defense"]

var current_skill: int

func _ready():
  print("[>] Set Data Battle Unit: ", SetDataBattleUnit())
  current_action = TypeState.CharacterTurn
  print("[>] Turn: ", TypeState.keys()[state])

func _process(_delta):
  match state:
    TypeState.CharacterTurn:
      print("Character Turn")
      _PerformCharacterTurn()
    TypeState.ActionChoice:
      _PerformActionChoice()
      # print("Action Choice")
    TypeState.SkillChoice:
      _PerformSkillChoice()
  pass

func SetDataBattleUnit():
  if player == null or enemy == null:
    return false
  player.SetUp()
  player.SetModel3D()
  enemy.SetUp()
  enemy.SetModel3D()
  for unit in [player, enemy]:
    is_player_unit_set_up(unit)
  print("[>] Player: ", player)
  return true

func is_player_unit_set_up(_unit: BattleUnit):
  if !_unit.isPlayerUnit:
    _unit.rotation.y = deg_to_rad(180)

func _on_button_attack_pressed() -> void:
  if player == null or enemy == null:
    return
  enemy.character.TakeDamage(null, player.character)
  player.hud.UpdateHP()
  enemy.hud.UpdateHP()
  # player.PrintCharacter()
  pass # Replace with function body.

# <------------------------------------------------> #
# <Perform>
func _PerformCharacterTurn():
  _PerformPlayerTurn()
  return

func _PerformPlayerTurn():
  state = TypeState.ActionChoice
  return

func _PerformEnemyTurn():
  state = TypeState.CharacterTurn
  return

func _PerformActionChoice():
  if Input.is_action_just_pressed("ui_skill_1"):
    current_action = 1
    print("[>] Action - choice: ", current_action)
  if Input.is_action_just_pressed("ui_skill_2"):
    current_action = 2
    print("[>] Action - choice: ", current_action)
  if Input.is_action_just_pressed("ui_skill_3"):
    current_action = 3
    print("[>] Action - choice: ", current_action)
  if Input.is_action_just_pressed("ui_skill_4"):
    current_action = 4
    print("[>] Action - choice: ", current_action)
  
  if Input.is_action_just_pressed("ui_accept"):
    MyCurrentAction()
    match max(0, current_action - 1):
      0:
        state = TypeState.SkillChoice
      _:
        state = TypeState.ActionChoice
  return 0

func _PerformSkillChoice():
  if Input.is_action_just_pressed("ui_skill_1"):
    current_skill = 1
    print("[>] Skill - choice: ", current_skill)
  if Input.is_action_just_pressed("ui_skill_2"):
    current_skill = 2
    print("[>] Skill - choice: ", current_skill)
  if Input.is_action_just_pressed("ui_skill_3"):
    current_skill = 3
    print("[>] Skill - choice: ", current_skill)
  if Input.is_action_just_pressed("ui_skill_4"):
    current_skill = 4
    print("[>] Skill - choice: ", current_skill)
  
  if Input.is_action_just_pressed("ui_accept"):
    MyCurrentSkill()
    _CheckHP()
    if !enemy.character.hp <= 0:
      state = TypeState.CharacterTurn
  return 0
# </Perform>

func MyCurrentAction():
  var current = max(0, current_action - 1)
  print("[>] current: ", current, ", actions: ", actions.size())
  if (current) < actions.size():
    print("[>] Action: ", actions[current])

func MyCurrentSkill():
  print("[>] current: ", current_skill - 1, ", skills: ", player.character.skills.size())
  if (current_skill - 1) < player.character.skills.size():
    _RunSkill(player, enemy, player.character.skills[current_skill - 1])
    player.RunAnimation3D("fight")

func _RunSkill(_source: BattleUnit, _target: BattleUnit, _skill: Skill):
  _skill._RunCore(_source.character, _target.character)
  return 0

func _CheckHP():
      print("[>] player: ", player.character.hp, "/", player.character.max_hp)
      print("[>] player:", player.character.attribute_modified)
      print("[>] enemy: ", enemy.character.hp, "/", enemy.character.max_hp)