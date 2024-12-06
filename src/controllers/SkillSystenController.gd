class_name SkillSystenController

var battle_system_controller: BattleSystemController

var current_target: int = 0

# Danh sách các target có thể được chọn
var group_target: Array[UnitModel]
# Danh sách các target mục tiêu chính của skill
var group_current_target: Array[UnitModel]

var player_group: Array[UnitModel]:
  get:
    return battle_system_controller.player_group
var enemy_group: Array[UnitModel]:
  get:
    return battle_system_controller.enemy_group

func _init(_system: BattleSystemController):
  battle_system_controller = _system
  return

func set_current_target(_value: int):
  if _value >= group_target.size():
    current_target = 0
    return
  
  if _value < 0:
    current_target = group_target.size()
    return

  current_target = _value
  return

func perform_select_target_type(_skill: SkillModel, _source: UnitModel):

  if _skill == null or _source == null:
    reset_perform()
    return

  # Lọc kiểu target và group các unit sẽ bị target: 
  # ==> Self -> 1 unit, Enemy / Ally -> group unit, Any -> all unit
  match _skill.target_type:
    SkillBase.TargetType.SELF:
      group_target = [_source]
    SkillBase.TargetType.ENEMY:
      group_target = enemy_group
    SkillBase.TargetType.ALLY:
      group_target = player_group
    SkillBase.TargetType.ANY:
      group_target = player_group + enemy_group
  
  perform_select_target_mode(_skill, _source)
  return

func perform_select_target_mode(_skill: SkillModel, _source: UnitModel):
  if Input.is_action_just_pressed("ui_left"):
    set_current_target(current_target - 1)
    perform_get_select_target(_skill, _source)
  if Input.is_action_just_pressed("ui_right"):
    set_current_target(current_target + 1)
    perform_get_select_target(_skill, _source)
  
  if Input.is_action_just_pressed("ui_accept"):
    battle_system_controller.state = BattleSystemController.State.EndState
    pass
  pass

func perform_get_select_target(_skill: SkillModel, _source: UnitModel):
  match _skill.target_mode:
    # tất cả đối tượng
    SkillBase.TargetMode.ALL:
      group_current_target = group_target
      pass
    # Một đối tượng
    SkillBase.TargetMode.SINGLE:
      group_current_target = [group_target[current_target]]
      pass
    # Ba đối tượng
    SkillBase.TargetMode.THREE:
      var start: int = max(0, current_target - 1)
      var end: int = min(group_target.size(), current_target + 2)
      group_current_target = group_target.slice(start, end - start)
      pass


func reset_perform():
  group_target.clear()
  group_current_target.clear()
  current_target = 0
  pass