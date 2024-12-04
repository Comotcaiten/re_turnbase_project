class_name SkillSystenController

var battle_system_controller: BattleSystemController

var current_target: int = 0

var group_target: Array[UnitModel]
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

func perform_select_target_type(_skill: SkillModel, _source: UnitModel):

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
  return

func perform_select_target_mode(_skill: SkillModel, _source: UnitModel):

  if Input.is_action_just_pressed("ui_left"):
    current_target -= 1
    if current_target <= 0:
      current_target = group_target.size() - 1
    perform_get_select_target_mode(_skill, _source)
  if Input.is_action_just_pressed("ui_right"):
    current_target += 1
    if current_target >= group_target.size():
      current_target = 0
    perform_get_select_target_mode(_skill, _source)
  pass

func perform_get_select_target_mode(_skill: SkillModel, _source: UnitModel):
  match _skill.target_mode:
    SkillBase.TargetMode.ALL:
      group_current_target = group_target
      pass
    SkillBase.TargetMode.SINGLE:
      group_current_target = [group_target[current_target]]
      pass
    SkillBase.TargetMode.THREE:
      var left: int = current_target - 1
      var middle: int = current_target
      var right: int = current_target + 1
      group_current_target = []
      if !(left < 0):
        group_current_target.append(group_target[left])
      if !(middle < 0 or middle >= group_target.size()):
        group_current_target.append(group_target[middle])
      if !(right >= group_current_target.size()):
        group_current_target.append(group_target[right])
      pass