extends Node

class_name SkillSystemController

enum State {Start, Select, Execute, End}

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

@export var battle_system: BattleSystemController

#--------------------------------------------------------------------------------
# Hàm chính

func perform_random_skill():
	match state:
		State.Start:
			if battle_system == null or battle_system.current_unit == null:
				print("battle_system == null or battle_system.current_unit == null")
				print("battle_system.current_unit == null: ", battle_system.current_unit)
				state = State.End
			if battle_system.current_unit.skills.is_empty():
				print("battle_system.current_unit.skills.is_empty")
				state = State.End
				return
			# First: Choice skill
			set_skill(battle_system.current_unit.get_random_skill())

			if current_skill_select == null:
				print()
				state = State.End
			# Second: Skill based targets can slecet => groups can be select
			perform_get_group_targets()
			# Third: Select some units will be take effect of skills

			# set_current_id_target(randi() % max(1, group_target.size()))
			perform_get_select_targets()
			# Four:
			state = State.Select
		State.Select:
			state = State.Execute			
		State.Execute:
			perform_run_skill()
			pass
		State.End:
			battle_system.get_next_turn()
			state = State.Start
			refresh()
			pass
			

func perform_skill():
	match state:
		State.Start:
			if battle_system == null or battle_system.current_unit == null:
				print("battle_system == null or battle_system.current_unit == null")
				print("battle_system.current_unit == null: ", battle_system.current_unit)
				state = State.End
			# First: Choice skill
			set_skill(battle_system.current_unit.get_skill(0))
			# Second: Skill based targets can slecet => groups can be select
			perform_get_group_targets()
			# Third: Select some units will be take effect of skills
			perform_get_select_targets()
			# Four:
			state = State.Select
		State.Select:
			perform_select_skill()
			
		State.Execute:
			perform_run_skill()
			pass
		State.End:
			battle_system.get_next_turn()
			state = State.Start
			refresh()
			pass

func perform_select_skill():
	if battle_system == null:
		return
	
	if Input.is_action_just_pressed("ui_action_1"):
		set_skill(battle_system.current_unit.get_skill(0))
		perform_get_group_targets()
	if Input.is_action_just_pressed("ui_action_2"):
		set_skill(battle_system.current_unit.get_skill(1))
		perform_get_group_targets()
	if Input.is_action_just_pressed("ui_action_3"):
		set_skill(battle_system.current_unit.get_skill(2))
		perform_get_group_targets()
	if Input.is_action_just_pressed("ui_action_4"):
		set_skill(battle_system.current_unit.get_skill(3))
		perform_get_group_targets()
	perform_select_targets()
	if Input.is_action_just_pressed("ui_accept"):
		state = State.Execute
		return
	return

func perform_select_targets():

	if Input.is_action_just_pressed("ui_left"):
		set_current_id_target(current_id_target - 1)
		perform_get_select_targets()
	if Input.is_action_just_pressed("ui_right"):
		set_current_id_target(current_id_target + 1)
		perform_get_select_targets()

func perform_run_skill():
	print("Run Skill")
	current_skill_select.run(group_target_select, battle_system.current_unit, battle_system)
	state = State.End
	return

func perform_get_group_targets() -> bool:
	if current_skill_select == null or battle_system == null or battle_system.current_unit == null:
		return false
	
	if battle_system.maps_unit_groups_controller.is_empty():
		return false
	
	if battle_system.maps_unit_groups_controller.size < 2:
		return false
	
	var groups: Array[UnitModel] = battle_system.get_all_units()

	match current_skill_select.target_type:
		SkillBase.TargetType.SELF:
			groups = [battle_system.current_unit]
		SkillBase.TargetType.ENEMY:
			groups = groups.filter(func(x):
				return x.team !=  battle_system.current_unit.team
			)
		SkillBase.TargetType.ALLY:
			groups = groups.filter(func(x):
				return x.team == battle_system.current_unit.team
			)
		SkillBase.TargetType.ANY:
			groups = groups

	match current_skill_select.target_fainted:
		SkillBase.TargetFainted.TRUE:
			groups = groups.filter(func(x):
				return x.is_fainted
			)
		SkillBase.TargetFainted.FALSE:
			groups = groups.filter(func(x):
				return !x.is_fainted
			)
	
	group_target = (groups as Array[UnitModel])
	print("Group_target: ", group_target)
	perform_get_select_targets()
	return true

func perform_get_select_targets():
	if current_id_target == null:
		group_target_select = []
		return false

	match current_skill_select.target_mode:
		SkillBase.TargetMode.ALL:
			group_target_select = group_target
		SkillBase.TargetMode.SINGLE:
			group_target_select = [target]
		SkillBase.TargetMode.THREE:
			var start: int = max(0, current_id_target - 1)
			var end: int = min(group_target.size(), current_id_target + 2)
			group_target_select = group_target.slice(start, end)
	show_icon_target()
	print("Group select: ", group_target_select)
	return true
#--------------------------------------------------------------------------------
# Hàm event

func show_icon_target():
	for unit in group_target:
		if unit in group_target_select:
			unit.change_mesh_target()
		else:
			unit.change_mesh_normal()

func refresh():
	for unit in group_target:
		unit.change_mesh_normal()
	
	current_id_target = 0
	current_skill_select = null
	group_target = []
	group_target_select = []

#--------------------------------------------------------------------------------
# Hàm set
func set_current_id_target(_value: int) -> bool:
	if group_target.size() <= 0:
		return false

	if _value >= group_target.size():
		current_id_target = 0
		return true
	
	if _value < 0:
		current_id_target = group_target.size() - 1
		return true

	current_id_target = _value
	print("Current id target: ", current_id_target)
	return true

func set_skill(skill: SkillModel) -> bool:
	if skill == null:
		print("Current skill: ", current_skill_select)
		return false
	
	current_skill_select = skill

	print("Current skill: ", current_skill_select)
	return true

# func set_group_target(groups: Array[UnitModel]):
# 	if groups.is_empty():
# 		return false
# 	group_target = groups
# 	return true
#--------------------------------------------------------------------------------
# Hàm lọc
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
