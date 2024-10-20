extends Node
class_name BattleSystemController

enum TypeState {CharacterTurn, ActionChoice, SkillChoice}

@export var player: BattleUnitModel
@export var enemy: BattleUnitModel

var unit_service: UnitService = UnitService.new()

var state: TypeState

var current_action: int:
  set(value):
    if !(value >= actions.size()):
      current_action = value
    print("[>] current_action: ", current_action)
var actions = ["Attack", "Defense"]

var current_skill: int

func _ready():
  player.set_data()
  enemy.set_data()
  unit_service.print_data(player.unit)
  unit_service.print_data(enemy.unit)
  state = TypeState.CharacterTurn
  pass

func _process(_delta):
  match state:
    TypeState.CharacterTurn:
      perform_state_player()
    TypeState.ActionChoice:
      perform_state_action()
    TypeState.SkillChoice:
      perform_state_skill()
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
  print("[>] actions: ", actions[current_action])

  match current_action:
    0:
      state = TypeState.SkillChoice
    _:
      state = TypeState.ActionChoice

func perform_state_skill():
  if Input.is_action_just_pressed("ui_skill_1"):
    set_current_skill(0)
  if Input.is_action_just_pressed("ui_skill_2"):
    set_current_skill(1)
  if Input.is_action_just_pressed("ui_skill_3"):
    set_current_skill(2)
  if Input.is_action_just_pressed("ui_skill_4"):
    set_current_skill(3)

  if Input.is_action_just_pressed("ui_accept"):
    perform_skill_choice()

func perform_skill_choice():
  if player.unit.skills == []:
    return
  if player.unit.skills[current_skill] == null:
    return
  print("[>] skill: ", player.unit.skills[current_skill])

  var is_fainted = run_skill(enemy, player, player.unit.skills[current_skill])
  print("[>] Player: ", unit_service.get_hp(player.unit))
  unit_service.print_data(player.unit)
  print("[>] Enemy: ", unit_service.get_hp(enemy.unit))
  unit_service.print_data(enemy.unit)
  print("[>] is_fainted: ", is_fainted)
  if is_fainted and !enemy.is_fainted:
    enemy.is_fainted = is_fainted
    on_unit_death(enemy.unit, player.unit)
    on_unit_killed(enemy.unit, player.unit)
    print("[>] ------")

func set_current_skill(_value: int):
  if !(_value >= player.unit.skills.size()):
    current_skill = _value
  print("[>] current_skill: ", current_skill)
  return

func run_skill(_target: BattleUnitModel, _source: BattleUnitModel, _skill: SkillModel):
  _skill.use(_target.unit, _source.unit)

  return _target.unit.hp <= 0


# <For combat passive>
func on_unit_killed(_target: UnitModel, _source: UnitModel):
  # The _source killed _target
  # for skill in _source.skills_passive:
  #   if skill.base.trigger == SkillBase.Trigger.Kill:
  #     skill.use(_target, _source)
  print("[>] ", _source.name, " killed ", _target.name)
  return

func on_unit_death(_target: UnitModel, _source: UnitModel):
  # The _target death by _source
  # source: attacker, target: the death one
  # for skill in _target.skills_passive:
  #   if skill.base.trigger == SkillBase.Trigger.Death:
  #     skill.use(_target, _source)
  print("[>] ", _target.name, " death by ", _source.name)
  return
# </For combat passive>