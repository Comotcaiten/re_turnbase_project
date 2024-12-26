extends Node

class_name SkillSystemController

enum State {Start, Pervious, Select, ExecuteSkill, End}

var state: State = State.Start

var current_id_target: int = 0
var target: UnitModel:
	get:
		return group_target[current_id_target]

# var current_id_skill: int = 0
var current_skill_select: SkillModel = null

# Danh sách các target có thể được chọn
var group_target: Array[UnitModel]
# Danh sách các target/mục tiêu chính của skill
var group_target_select: Array[UnitModel]


func perform_skil(source: UnitModel, battle_system: BattleSystemController):
	match state:
		State.Start:
			# First: Set default
			current_skill_select = source.get_skill(0)
			state = State.Pervious
			pass
		State.Pervious:
			# Set up group target
			perform_get_target(source, battle_system)
			pass
		State.Select:
			# Select skill and target
			perform_select_skill(source, battle_system)
			pass
		State.ExecuteSkill:
			pass
		State.End:
			pass
	return

func perform_get_target(source: UnitModel, battle_system: BattleSystemController):
	group_target = get_group_target_can_get_from_skill(source, battle_system)
	if group_target.is_empty():
		state = State.End
		return

	state = State.Select
	return

func perform_select_target(source: UnitModel, battle_system: BattleSystemController):
	if source == null or battle_system == null:
		state = State.End
		return

	if Input.is_action_just_pressed("ui_left"):
		set_current_id_target(current_id_target - 1)
		group_target_select = get_group_target_select()
	if Input.is_action_just_pressed("ui_right"):
		set_current_id_target(current_id_target + 1)
		group_target_select = get_group_target_select()

	if group_target_select.is_empty():
		state = State.End
		return
	return

func perform_select_skill(source: UnitModel, battle_system: BattleSystemController):

	if Input.is_action_just_pressed("ui_action_1"):
		current_skill_select = source.get_skill(0)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_2"):
		current_skill_select = source.get_skill(1)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_3"):
		current_skill_select = source.get_skill(2)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_4"):
		current_skill_select = source.get_skill(3)
		perform_get_target(source, battle_system)
	
	perform_select_target(source, battle_system)

	if Input.is_action_just_pressed("ui_accept"):
		# perform_run_skill(source)
		print("Run skill ", current_skill_select.name)

func get_group_target_can_get_from_skill(source: UnitModel, battle_system: BattleSystemController) -> Array[UnitModel]:
	if current_skill_select == null or source == null or battle_system == null:
		return []
	
	if battle_system.maps_unit_groups_controller.is_empty():
		return []
	
	if battle_system.maps_unit_groups_controller.size < 2:
		return []
	
	var group: Array[UnitModel] = battle_system.get_all_units()
	group = filter_target_type(group, source)
	group = filter_target_fainted(group)
	
	return group

func get_group_target_select() -> Array[UnitModel]:
	if current_skill_select == null:
		return []
	
	match current_skill_select.target_mode:
		SkillBase.TargetMode.ALL:
			return group_target
		SkillBase.TargetMode.SINGLE:
			return [target]
		SkillBase.TargetMode.THREE:
			var start: int = max(0, current_id_target - 1)
			var end: int = min(group_target.size(), current_id_target + 2)
			return group_target.slice(start, end)
		_:
			return []

func set_current_id_target(_value: int):
	if _value >= group_target.size():
		current_id_target = 0
		return
	
	if _value < 0:
		current_id_target = group_target.size() - 1
		return

	current_id_target = _value
	return

func filter_target_type(groups: Array[UnitModel] = [], source: UnitModel = null) -> Array[UnitModel]:
	if groups.is_empty() or groups.size() <= 0:
		return []
	
	match current_skill_select.target_type:
		SkillBase.TargetType.SELF:
			return [source]
		SkillBase.TargetType.ENEMY:
			return groups.filter(func(x):
				return x.team != source.team
			)
		SkillBase.TargetType.ALLY:
			return groups.filter(func(x):
				return x.team == source.team
			)
		SkillBase.TargetType.ANY:
			return groups
	return []

func filter_target_fainted(groups: Array[UnitModel] = []) -> Array[UnitModel]:
	match current_skill_select.target_fainted:
		SkillBase.TargetFainted.NONE:
			return groups
		SkillBase.TargetFainted.TRUE:
			return groups.filter(func(x):
				return x.is_fainted
			)
		SkillBase.TargetFainted.FALSE:
			return groups.filter(func(x):
				return !x.is_fainted
			)
	return []
