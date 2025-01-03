extends Node

class_name SkillSystemController

enum State {Start, Select, ExecuteSkill, End}

var state: State = State.Start

var current_id_target: int = 0
var target: UnitModel:
	get:
		if group_target.is_empty():
			return null
		return group_target[current_id_target]

# var current_id_skill: int = 0
var current_skill_select: SkillModel = null

# Danh sách các target có thể được chọn
var group_target: Array[UnitModel]
# Danh sách các target/mục tiêu chính của skill
var group_target_select: Array[UnitModel]

#--------------------------------------------------------------------------------
# Hàm chính
func perform_skill(source: UnitModel, battle_system: BattleSystemController):

	if check_data(source, battle_system):
		return

	match state:
		State.Start:
			# Set default
			print("First: Set default")
			# Set default skill select
			current_skill_select = source.get_skill(0)
			# Get target can be select from battle system by skill
			perform_get_target(source, battle_system)
			# Get group target select by skill
			group_target_select = get_group_target_select()
			print("Current target select: ", group_target_select)
			print("Current skill: ", current_skill_select)

			state = State.Select
			pass
		State.Select:
			# Select skill and target
			perform_select_skill(source, battle_system)
			pass
		State.ExecuteSkill:
			print("Execute skill")
			perform_run_skill(source, battle_system)
			pass
		State.End:
			print("End")
			# battle_system.state = BattleSystemController.State.End
			battle_system.get_next_turn()

			# refresh
			current_id_target = 0
			current_skill_select = null
			group_target.clear()

			state = State.Start
			pass
	return

func perform_skill_random(source: UnitModel, battle_system: BattleSystemController):

	if check_data(source, battle_system):
		return

	# First: Get random skill
	set_skill(source.get_random_skill())
	# Second: Get target can be select from battle system by skill
	perform_get_target(source, battle_system)
	# Third: Get main target select
	current_id_target = randi() % group_target.size()
	print("current_id_target: ", current_id_target)
	# Fourth: Get group target select by skill
	group_target_select = get_group_target_select()
	print("Current skill: ", current_skill_select)

	perform_run_skill(source, battle_system)

	battle_system.get_next_turn()
	return

func perform_get_target(source: UnitModel, battle_system: BattleSystemController):
	group_target = get_group_target_can_get_from_skill(source, battle_system)

	if group_target.is_empty():
		print("Group target is empty")
		return

	print("Group target: ", group_target)
	state = State.Select
	return

func perform_select_target(source: UnitModel, battle_system: BattleSystemController):
	if source == null or battle_system == null:
		print("Source or battle system is null")
		state = State.End
		return

	if Input.is_action_just_pressed("ui_left"):
		set_current_id_target(current_id_target - 1)
		group_target_select = get_group_target_select()
		for unit in group_target:
			if unit in group_target_select:
				unit.change_mesh_target()
			elif unit not in group_target_select:
				unit.change_mesh_normal()
		print("Current target select: ", group_target_select)

	if Input.is_action_just_pressed("ui_right"):
		set_current_id_target(current_id_target + 1)
		group_target_select = get_group_target_select()
		for unit in group_target:
			if unit in group_target_select:
				unit.change_mesh_target()
			elif unit not in group_target_select:
				unit.change_mesh_normal()
		print("Current target select: ", group_target_select)

	# if group_target_select.is_empty():
	# 	print("Group target select is empty")
	# 	return
	return

func perform_select_skill(source: UnitModel, battle_system: BattleSystemController):

	if Input.is_action_just_pressed("ui_action_1"):
		set_skill(source.get_skill(0))
		print("Current skill: ", current_skill_select)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_2"):
		set_skill(source.get_skill(1))
		print("Current skill: ", current_skill_select)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_3"):
		set_skill(source.get_skill(2))
		print("Current skill: ", current_skill_select)
		perform_get_target(source, battle_system)
	if Input.is_action_just_pressed("ui_action_4"):
		set_skill(source.get_skill(3))
		print("Current skill: ", current_skill_select)
		perform_get_target(source, battle_system)
	
	perform_select_target(source, battle_system)

	if Input.is_action_just_pressed("ui_accept"):
		# perform_run_skill(source)
		print("Run skill ", current_skill_select)
		state = State.ExecuteSkill
	return

func perform_run_skill(source: UnitModel, battle_system: BattleSystemController):
	if source == null or battle_system == null:
		print("Source or battle system is null")
		state = State.End
		return

	if current_skill_select == null:
		print("Current skill is null")
		state = State.End
		return

	# Run skill
	# source.run_skill(current_skill_select, group_target_select)
	current_skill_select.run(group_target_select, source, battle_system)
	state = State.End
	return
#--------------------------------------------------------------------------------
# Hàm xử lý
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
#--------------------------------------------------------------------------------
# Hàm set
func set_current_id_target(_value: int):
	if _value >= group_target.size():
		current_id_target = 0
		return
	
	if _value < 0:
		current_id_target = group_target.size() - 1
		return

	current_id_target = _value
	return

func set_skill(skill: SkillModel) -> bool:
	if skill == null:
		return false
	
	current_skill_select = skill
	return true
#--------------------------------------------------------------------------------
# Hàm lọc
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

# --------------------------------------------------------------------------------

func check_data(source: UnitModel, battle_system: BattleSystemController) -> bool:
	if source == null or battle_system == null:
		print("Source or battle system is null")
		return true
	
	if source.skills.is_empty():
		print("Source skills is empty")
		battle_system.get_next_turn()
		return true
	return false
