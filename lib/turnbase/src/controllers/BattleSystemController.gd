extends Node
class_name BattleSystemController

enum TypeState {CharacterTurn, ActionChoice, TargetChoice, SkillChoice, EndBattle}

var unit_service: UnitService = UnitService.new()

# <Units in Battle>
@export var player: BattleUnitModel
var units_player: Array[BattleUnitModel]:
  get:
    return [player]

@export var units_enemy: Array[BattleUnitModel]:
  get:
    var arr: Array[BattleUnitModel] = []
    for unit in units_enemy:
      if unit != null:
        arr.append(unit)
    return arr

var units: Array[BattleUnitModel]:
  get:
    return units_player + units_enemy
# </Units in Battle>

var state: TypeState

# <Action>
var actions = ["Attack", "Defense"]

var current_action: int:
  set(value):
    if !(value > actions.size() - 1): # Sửa ở đây
      current_action = value
    print("[>] current_action: ", current_action)
# </Action>

# <Target>
var current_target: int:
  set(_value):
    if !(_value > units.size() - 1): # Sửa ở đây
      current_target = _value
  get:
    print("[>] current_target: ", current_target)
    print("[>] target: ", units[current_target].unit.name)
    return max(0, current_target)
# </Target>

# <Skill>
var current_skill: int:
  get:
    return max(0, current_skill)
# </Skill>

# <Turn queue>
var turn_queue: Array[BattleUnitModel] = []
var current_unit_index: int = 0
# </Turn queue>

# <Game>
func _ready():
  print("[>] units: ", units)
  for unit in units:
    unit.set_data()

  # Tạo hàng đợi lượt từ các đơn vị
  turn_queue = units_player + units_enemy
  state = TypeState.CharacterTurn
  pass

func _process(_delta):
  match state:
    TypeState.CharacterTurn:
      perform_state_character()
    TypeState.ActionChoice:
      perform_state_action()
    TypeState.SkillChoice:
      perform_state_skill()
    TypeState.EndBattle:
      perform_state_end_battle()
  pass
# </Game>

func next_turn():
  if check_fainted_units(units_player) or check_fainted_units(units_enemy):
    state = TypeState.EndBattle
    print("[>] <END>-------------------------------------</END>")
    return
  else:
    print("[>] ------------------------------------------------")
  
  current_unit_index += 1
  if current_unit_index >= turn_queue.size():
      current_unit_index = 0 # Quay lại đơn vị đầu tiên nếu hết lượt
    
  var current_unit = turn_queue[current_unit_index]
  if current_unit.is_fainted:
    print("[>] Đơn vị ", turn_queue[current_unit_index].name, " is fainted, Skip")
    next_turn() # Nếu đơn vị đã bị hạ gục, bỏ qua và chuyển lượt
  else:
    print("[>] Lượt của đơn vị: ", current_unit.unit.name)
    state = TypeState.CharacterTurn # Quay lại trạng thái để xử lý lượt của đơn vị

# <Perform>
func perform_state_character():
  # Logic để xử lý lượt của người chơi (như chọn hành động, mục tiêu, kỹ năng, v.v.)

  if turn_queue[current_unit_index].is_player:
    print("[>] Player state")
    state = TypeState.ActionChoice
  else:
    print("[>] Enemy state")
    perform_state_enemy_turn()
  return

func perform_state_enemy_turn():
  if turn_queue[current_unit_index].is_player:
    return
  var skill = turn_queue[current_unit_index].unit.get_random_skill_combat()
  if skill == null:
    next_turn()
    return
  perform_run_skill(get_random_target_player(), turn_queue[current_unit_index], skill)

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
  if player.unit.skills.is_empty():
    return
  if player.unit.skills[current_skill] == null:
    return
  
  if units[current_target].unit.hp <= 0:
    return

  perform_run_skill(units[current_target], player, player.unit.skills[current_skill])

func perform_state_is_fainted(_target: BattleUnitModel, _source: BattleUnitModel, _skill: SkillModel):
  var is_fainted = _target.unit.hp <= 0
  if is_fainted and (!(units[current_target].is_fainted) and units[current_target] == _target):
    print("[>] ", _target.unit.name, " is fainted")
    units[current_target].is_fainted = is_fainted
    on_unit_death(units[current_target].unit, player.unit)
    on_unit_killed(units[current_target].unit, player.unit)
  
  # if !check_fainted_units(units_player) or !check_fainted_units(units_enemy):
  next_turn()
  return

func perform_run_skill(_target: BattleUnitModel, _source: BattleUnitModel, _skill: SkillModel):
  _skill.use(_target.unit, _source.unit)
  print("[>] ", _source.unit.name, " use ", _skill.base.name, " on ", _target.unit.name)
  update_hp()
  perform_state_is_fainted(_target, _source, _skill)
  return

func perform_state_end_battle():
  return
# </Perform>

# <Get>
func get_random_target_player():
  var target: BattleUnitModel = units_player[randi() % units_player.size()]
  while target == null or target.is_fainted:
    target = units_player[randi() % units_player.size()]
  return target
# </Get>

# <Set>
func set_current_skill(_value: int):
  if !(_value >= player.unit.skills_combat.size()):
    current_skill = _value
  print("[>] current_skill: ", player.skills_combat[current_skill].base.name)
  return
# </Set>

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

func update_hp():
  for unit in units:
    print("[>] ", unit.unit.name, " :", unit.unit.hp, "/", unit.unit.max_hp, " HP")
    print("[>] <Data>")
    unit_service.print_data(unit.unit)
    print("[>] </Data>")

func check_fainted_units(_units: Array[BattleUnitModel]) -> bool:
  for unit in _units:
    if !unit.is_fainted:
      return false
  state = TypeState.EndBattle
  return true