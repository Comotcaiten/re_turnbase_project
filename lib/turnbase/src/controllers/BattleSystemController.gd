extends Node
class_name BattleSystemController

enum TypeState {CharacterTurn, ActionChoice, TargetChoice, SkillChoice}

@export var player: BattleUnitModel

var units_player: Array[BattleUnitModel]:
  get:
    return [player]

@export var units_enmey: Array[BattleUnitModel]:
  get:
    var arr: Array[BattleUnitModel] = []
    for unit in units_enmey:
      if unit != null:
        arr.append(unit)
    return arr

var units: Array[BattleUnitModel]:
  get:
    return units_player + units_enmey

var unit_service: UnitService = UnitService.new()

var state: TypeState

var current_action: int:
  set(value):
    if !(value >= actions.size()):
      current_action = value
    print("[>] current_action: ", current_action)
var actions = ["Attack", "Defense"]

var current_target: int:
  set(_value):
    if !(_value >= units.size()):
      current_target = _value
    print("[>] current_target: ", current_target)
    print("[>] target: ", units[current_target].unit.name)

var current_skill: int

func _ready():
  print("[>] units: ", units)
  for unit in units:
    unit.set_data()
    unit_service.print_data(unit.unit)

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

func perform_state_target():
  if Input.is_action_just_pressed("ui_left"):
    current_target -= 1
    if current_target == 0:
      current_target = units.size() - 1
    return
  if Input.is_action_just_pressed("ui_right"):
    current_target += 1
    if current_target == units.size():
      current_target = units.size() - 1
    return
  return

func perform_state_skill():
  perform_state_target()
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
  
  if units[current_target].unit.hp <= 0:
    print("[>] _target have hp <= 0")
    return
  print("[>] skill: ", player.unit.skills[current_skill])

  var is_fainted = run_skill(units[current_target], player, player.unit.skills[current_skill])

  print("[>] is_fainted: ", is_fainted)

  print("[>] <Before>")
  print("[>] Player: ", player.unit.name, ": ", unit_service.get_hp(player.unit))
  print("[>] Target: ", units[current_target].unit.name, ": ", unit_service.get_hp(units[current_target].unit))

  if is_fainted and !(units[current_target].is_fainted):
    units[current_target].is_fainted = is_fainted
    on_unit_death(units[current_target].unit, player.unit)
    on_unit_killed(units[current_target].unit, player.unit)

    print("[>] <After>")
    print("[>] Player: ", unit_service.get_hp(player.unit))
    print("[>] Target: ", unit_service.get_hp(units[current_target].unit))

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
  for skill in _source.skills_passive:
    if skill.base.trigger == SkillBase.Trigger.Kill:
      print("[>] Perform passive skill trigger by killed: ", _source.name, " killed ", _target.name)
  return

func on_unit_death(_target: UnitModel, _source: UnitModel):
  # The _target death by _source
  # source: attacker, target: the death one
  for skill in _target.skills_passive:
    if skill.base.trigger == SkillBase.Trigger.Death:
      skill.use(_source, _target)
  print("[>] [>] Perform passive skill trigger by death: ", _target.name, " death by ", _source.name)
  return
# </For combat passive>