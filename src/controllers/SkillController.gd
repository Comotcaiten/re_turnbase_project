extends Node

class_name SkillController

enum State {START, SELECT, AISELECT, EXECUTE, END}

var state: State = State.START

var current_index: int
var current_skill: SkillModel

var current_target: int
var group_targets_available: Array[UnitModel] = []
var group_targets_select: Array[UnitModel] = []

var battle_system: BattleSystem

func initialized(_battle_system: BattleSystem):
    battle_system = _battle_system
    pass
# ---------------------------------------------------------

func play():
  pass

func change_state(_state: State):
  state = _state

func handle_start(unit: UnitModel):
  if unit.skills.is_empty():
    change_state(State.END)
    return
  group_targets_available = battle_system.group_controller.get_all_units()
  if unit.is_player:
    change_state(State.SELECT)
    return
  change_state(State.AISELECT)
  return

func handle_select(unit: UnitModel):
  if unit.skills.is_empty():
    change_state(State.END)
    return
  perform_handle_select(unit)
  return

func handle_ai_select(unit: UnitModel):
  if unit.skills.is_empty():
    change_state(State.END)
    return
  
  set_index_skill(randi() % max(0, unit.skills.size() - 1), unit)

  set_group_targets_available(unit)

  set_current_target(get_random_current_target())

  set_group_targets_select()
  
  change_state(State.EXECUTE)
  return

func handle_excute(unit: UnitModel):
  current_skill
  return

func handle_end():
  refesh()
  return

func perform_handle_select(unit: UnitModel):
  if Input.is_action_just_pressed("ui_action_1"):
    set_index_skill(0, unit)
    set_group_targets_available(unit)

  if Input.is_action_just_pressed("ui_action_1"):
    set_index_skill(1, unit)
    set_group_targets_available(unit)

  if Input.is_action_just_pressed("ui_action_1"):
    set_index_skill(2, unit)
    set_group_targets_available(unit)

  if Input.is_action_just_pressed("ui_action_1"):
    set_index_skill(3, unit)
    set_group_targets_available(unit)
  
  perform_handle_select_target()

  if Input.is_action_just_pressed("ui_accept"):
    change_state(State.EXECUTE)
  return

func perform_handle_select_target():
  if Input.is_action_just_pressed("ui_left"):
    set_current_target(current_target + 1)
    set_group_targets_select()
    return
  if Input.is_action_just_pressed("ui_right"):
    set_current_target(current_target - 1)
    set_group_targets_select()
    return
  
  return
  
# ---------------------------------------------------------
func set_index_skill(index: int, unit: UnitModel) -> bool:
  if unit.skills.is_empty():
    return false
  if index < 0 or current_index < 0:
    current_index = 0
    current_skill = null
    return false
  if current_index >= unit.skills.size():
    current_index = 0
    current_skill = null
    return false
  if index >= unit.skills.size():
    return false
  current_index = index

  current_skill = unit.get_skill(current_index)
  return true

func set_current_target(value: int):
  current_target = value
  if current_target < 0:
    current_target = group_targets_available.size()
  if current_target > group_targets_available.size():
    current_target = 0
  return

func set_group_targets_available(unit: UnitModel):
  if current_skill == null:
    group_targets_available = []
    return 
  match current_skill.target_type:
    SkillBase.TargetType.SELF:
      group_targets_available = [unit]
    SkillBase.TargetType.ENEMY:
      group_targets_available = battle_system.group_controller.get_group_is_player(false).group
    SkillBase.TargetType.ALLY:
      group_targets_available = battle_system.group_controller.get_group_is_player(true).group
    SkillBase.TargetType.ANY:
      group_targets_available = battle_system.group_controller.get_all_units()

  match current_skill.target_fainted:
    SkillBase.TargetFainted.NONE:
      return
    SkillBase.TargetFainted.TRUE:
      group_targets_available = battle_system.group_controller.filter_is_fainted(group_targets_available, true)
    SkillBase.TargetFainted.FALSE:
      group_targets_available = battle_system.group_controller.filter_is_fainted(group_targets_available, false)
  return
    
func set_group_targets_select():
  if group_targets_available.is_empty() or group_targets_available.size() <= current_target:
    group_targets_select = []
    return
  match current_skill.target_mode:
    SkillBase.TargetMode.ALL:
      group_targets_select = group_targets_available
      return
    SkillBase.TargetMode.THREE:
      var start: int = max(0, current_target - 1)
      var end: int = min(group_targets_available.size(), current_target + 2)
      group_targets_select = group_targets_available.slice(start, end)
      return
    SkillBase.TargetMode.SINGLE:
      group_targets_select = [group_targets_available[current_target]]
      return
  group_targets_select = []
  return

func get_skill(unit: UnitModel) -> SkillModel:
  if current_index >= unit.skills.size():
    return
  current_skill = unit.get_skill(current_index)
  return current_skill

func get_random_current_target() -> int:
  if group_targets_available.is_empty():
    return 0
  return randi() % group_targets_available.size()
func refesh():
  current_index = 0
  current_skill = null