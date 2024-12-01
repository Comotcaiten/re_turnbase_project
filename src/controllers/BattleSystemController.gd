extends Node
class_name BattleSystemController

enum Cycle {StartCycle, InsideCycle, EndCycle}
enum State {StartState, ActionState, SkillState, EndState}

# -------------------------------------------------------------------------------------
@export var player_group: Array[UnitModel]
@export var enemy_group: Array[UnitModel]

@export var label_count_cycle: Label
@export var lable_state: Label
@export var lable_action: Label
@export var label_turn: Label

@export var panel_skill: Panel

# all_unit: Chứa tất cả unit bao gồm cả những unit bị fainted
var all_unit: Array[UnitModel]:
  get:
    return player_group + enemy_group
# turn_queue: Chứa các unit chưa bị fainted và sắp xếp chúng để thực hiện hành động theo lượt ở từng cycle
var turn_queue: Array[UnitModel]:
  get:
    return get_turn_queue(player_group, enemy_group)

var cycle: Cycle
var state: State

var current_queue: int
var current_action: int
var current_skill: int
var count_cycle: int

@export var max_cycle: int = 10

var current_unit: UnitModel:
  get:
    return turn_queue[current_queue]
# -------------------------------------------------------------------------------------

func _ready():
  # print(turn_queue)
  # for unit in turn_queue:
  #   print(unit.character_base.name, ": ", unit.speed)

  set_panel_skill_visible(false)
  pass

func _process(_delta):
  match cycle:
    Cycle.StartCycle:
      perform_start_cycle()
    Cycle.InsideCycle:
      perform_inside_cycle()
    Cycle.EndCycle:
      perform_end_cycle()
  pass

# Cycle
# - Step 1
func perform_start_cycle():
  # print("Cycle: ", count_cycle)

  if label_count_cycle != null:
    label_count_cycle.text = str(count_cycle)

  cycle = Cycle.InsideCycle
  pass
# - Step 2
func perform_inside_cycle():
  if lable_state != null:
    lable_state.text = State.find_key(state)
  # Step 1
  match state:
    # Step 1.1
    State.StartState:
      perform_start_state()
      pass
    # Step 1.2
    State.ActionState:
      perform_action_state()
      pass
    # Step 1.3
    State.SkillState:
      perform_skill_state()
      pass
    # Step 1.4
    State.EndState:
      perform_end_state()
      pass
  # Step 2
  pass
# - Step 3
func perform_end_cycle():
  # Step 1
  if count_cycle >= max_cycle:
    return

  count_cycle += 1

  # Check xem các tất cả unit của các group có bị fainted hết không
  if get_units_group_fainted(player_group) or get_units_group_fainted(enemy_group):
    # Nếu tất cả unit của một trong các group đều fainted hết thì trả về và coi như dừng vòng lặp cycle
    return
  
  # Step 2
  # Nếu vẫn còn unit của một trong các group chưa bị fainted thì tiếp tục cycle
  # Reset cycle và bắt đầu cycle mới khi turn_queue/ Tất cả unit đi hết lượt của mình trong turn_queue
  reset_cycle()
  cycle = Cycle.StartCycle

func reset_cycle():
  current_queue = 0
  pass
  
# State
# - Step 1
func perform_start_state():
  if label_turn != null:
    label_turn.text = turn_queue[current_queue].name + " - " + str(turn_queue[current_queue].is_player)
  if turn_queue[current_queue].is_player:
    print("[Player]")
    state = State.ActionState
  else:
    # Nếu không phải player thì thực hiện các hành động
    print("[Enemy]")
    state = State.EndState
    pass
  pass
# - Step 2
func perform_action_state():
  # state = State.SkillState

  if Input.is_action_just_pressed("ui_action_1"):
    current_action = 0
    get_perform_action_state("Attack")
  if Input.is_action_just_pressed("ui_action_2"):
    current_action = 1
    get_perform_action_state("Bag")
  if Input.is_action_just_pressed("ui_action_3"):
    current_action = 2
    get_perform_action_state("Skill")
  if Input.is_action_just_pressed("ui_action_4"):
    current_action = 3
    get_perform_action_state("Run")
  
  if Input.is_action_just_pressed("ui_accept"):
    match current_action:
      0:
        pass
      1:
        pass
      2:
        state = State.SkillState
        pass
      3:
        state = State.EndState
        pass
  pass

func get_perform_action_state(_context: String):
  if lable_action != null:
    lable_action.text = str(current_action) + " - " + _context

# - Step 3
func perform_skill_state():
  # state = State.EndState
  set_panel_skill_visible(true)
  pass
# - Step 4
func perform_end_state():
  if Input.is_action_just_pressed("ui_accept"):
    # Step 1: Check xem các tất cả unit của các group có bị fainted hết không
    print(get_units_group_fainted(player_group) or get_units_group_fainted(enemy_group))
    if get_units_group_fainted(player_group) or get_units_group_fainted(enemy_group):
      # Thoát vòng lặp state
      cycle = Cycle.EndCycle
      return
    
    if current_queue >= turn_queue.size() - 1:
      cycle = Cycle.EndCycle
      return
    
    # Step 2: Tiếp tục với unit tiếp theo
    state = State.StartState

    get_next_turn()
  return

# TurnQueue
func get_units_group_fainted(_group: Array[UnitModel]) -> bool:
  if _group == []:
    return true
  for unit in _group:
    if unit == null:
      return true
    if unit.is_fainted == false:
      return false
  return true

func get_next_turn():
  # index
  current_queue += 1

  print("Next turn")
  pass

func get_turn_queue_merge_and_cut(_group: Array[UnitModel]) -> Array[UnitModel]:
  var n = _group.size()
  # Gộp mảng với chính nó
  _group += _group

  # Lấy mảng với độ dài n + 1
  return _group.slice(0, n + 1)

func get_turn_queue(_group1: Array[UnitModel], _group2: Array[UnitModel]) -> Array[UnitModel]:
  if _group1 == [] or _group2 == []:
    return []

  var _group: Array[UnitModel] = _group1 + _group2

  _group = get_turn_queue_merge_and_cut(_group)
  
  _group.filter(filter_is_not_fainted)
  _group.sort_custom(sort_by_speed)

  return _group

func update_turn_queue():
  turn_queue.filter(filter_is_not_fainted)
  turn_queue.sort_custom(sort_by_speed)
  return

func sort_by_speed(a: UnitModel, b: UnitModel):
  return a.speed > b.speed

func filter_is_not_fainted(a: UnitModel):
  return !a.is_fainted


# Panel
func set_panel_skill_visible(_visible: bool):
  if panel_skill != null:
    panel_skill.visible = _visible
  
# Skill