extends Node

class_name SkillController

enum State {START, SELECT, AISELECT, EXECUTE, END}

var state: State = State.START

var current_index: int
var current_target_filter: int
var current_skill: SkillModel

var current_target: int
var group_targets_available: Array[UnitModel] = []
var group_targets_available_filter: Array[UnitModel] = []
var group_targets_select: Array[UnitModel] = []

var battle_system: BattleSystem

func initialized(_battle_system: BattleSystem):
		battle_system = _battle_system
		pass
# ---------------------------------------------------------

func play(unit: UnitModel):
	match state:
		State.START:
			print("Skill controller >> Battle started!")
			handle_start(unit)
		State.SELECT:
			# print("Skill controller >> Select skill!")
			handle_select(unit)
		State.AISELECT:
			print("Skill controller >> AI select skill!")
			handle_ai_select(unit)
		State.EXECUTE:
			print("Skill controller >> Execute skill!")
			handle_excute(unit)
		State.END:
			# print("Skill controller >> End skill!")
			handle_end()
	pass

func change_state(_state: State):
	state = _state

func handle_start(unit: UnitModel):
	if unit.skills.is_empty():
		change_state(State.END)
		return
	if unit.skills.is_empty():
		change_state(State.END)
		return

	group_targets_available = battle_system.group_controller.get_all_units()

	set_index_skill(0, unit)
	set_group_targets_available(unit)
	var middle: int = int(group_targets_available.size() / 2.0)
	set_current_target(middle)
	set_group_targets_select()

	if unit in battle_system.group_controller.get_group_is_player().group:
		refactored_slelcted_by_skill()
	
	if unit.is_player:
		print("Selecting skill...")
		change_state(State.SELECT)
		return
	print("AI is thinking...")
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
	
	set_index_skill(randi() % max(1, unit.skills.size() - 1), unit)

	set_group_targets_available(unit)

	set_current_target(get_random_current_target())

	set_group_targets_select()
	
	change_state(State.EXECUTE)
	return

func handle_excute(unit: UnitModel):
	print("Skill controller >> Execute skill >> ", current_skill.name, " >> By >> ", unit.name)
	
	if current_skill is SkillModel:
		current_skill.excute(unit, group_targets_select)

	change_state(State.END)
	
	print("Skill controller >> Execute skill >> ", current_skill.name, " >> Done!")
	return

func handle_end():
	refesh()
	battle_system.get_next_turn()
	return

func perform_handle_select(unit: UnitModel):
	if Input.is_action_just_pressed("ui_action_1"):
		set_index_skill(0, unit)
		set_group_targets_available(unit)
		# print("Skill controller >> Select skill >> ", current_skill.name, " >> Group target available: ", group_targets_available)

	if Input.is_action_just_pressed("ui_action_2"):
		set_index_skill(1, unit)
		set_group_targets_available(unit)
		# print("Skill controller >> Select skill >> ", current_skill.name, " >> Group target available: ", group_targets_available)

	if Input.is_action_just_pressed("ui_action_3"):
		set_index_skill(2, unit)
		set_group_targets_available(unit)
		# print("Skill controller >> Select skill >> ", current_skill.name, " >> Group target available: ", group_targets_available)

	if Input.is_action_just_pressed("ui_action_4"):
		set_index_skill(3, unit)
		set_group_targets_available(unit)
		# print("Skill controller >> Select skill >> ", current_skill.name, " >> Group target available: ", group_targets_available)
	
	perform_handle_select_target()

	if Input.is_action_just_pressed("ui_accept"):
		change_state(State.EXECUTE)
	return

func perform_handle_select_target():
	if Input.is_action_just_pressed("ui_left"):
		set_current_target(current_target_filter - 1)
		set_group_targets_select()
		refactored_slelcted_by_skill()
		# print("Skill controller >> Select target >> Left >> ", current_target, " >> ", group_targets_select)
		return
	if Input.is_action_just_pressed("ui_right"):
		set_current_target(current_target_filter + 1)
		set_group_targets_select()
		refactored_slelcted_by_skill()
		# print("Skill controller >> Select target >> Right >> ", current_target, " >> ", group_targets_select)
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
	if value < 0:
		value = group_targets_available_filter.size() - 1
	if value >= group_targets_available_filter.size():
		value = 0
	current_target_filter = value
	current_target = group_targets_available.find(group_targets_available_filter[current_target_filter])
	return

func set_group_targets_available(unit: UnitModel):
	if current_skill == null:
		group_targets_available = []
		return
	match current_skill.target_type:
		SkillBase.TargetType.SELF:
			group_targets_available = [unit]
		SkillBase.TargetType.ENEMY:
			group_targets_available = battle_system.group_controller.get_group_is_enemy(unit)
		SkillBase.TargetType.ALLY:
			group_targets_available = battle_system.group_controller.get_group_is_ally(unit)
		SkillBase.TargetType.ANY:
			group_targets_available = battle_system.group_controller.get_all_units()
	
	match current_skill.target_fainted:
		SkillBase.TargetFainted.TRUE:
			group_targets_available_filter = group_targets_available.filter(func(x): return x.is_fainted) as Array[UnitModel]
		SkillBase.TargetFainted.FALSE:
			group_targets_available_filter = group_targets_available.filter(func(x): return not x.is_fainted) as Array[UnitModel]
		SkillBase.TargetFainted.NONE:
			group_targets_available_filter = group_targets_available
	return
		
func set_group_targets_select():
	if group_targets_available.is_empty() or group_targets_available.size() <= current_target:
		group_targets_select = []
		return
	match current_skill.target_mode:
		SkillBase.TargetMode.ALL:
			group_targets_select = group_targets_available

		SkillBase.TargetMode.THREE:
			var start: int = max(0, current_target - 1)
			var end: int = min(group_targets_available.size(), current_target + 2)
			group_targets_select = group_targets_available.slice(start, end)

		SkillBase.TargetMode.SINGLE:
			group_targets_select = [group_targets_available[current_target]]
		
		_:
			group_targets_select = []
	
	if group_targets_select.is_empty():
		return
	
	match current_skill.target_fainted:
		SkillBase.TargetFainted.TRUE:
			group_targets_select = group_targets_select.filter(func(x): return x.is_fainted) as Array[UnitModel]
		SkillBase.TargetFainted.FALSE:
			group_targets_select = group_targets_select.filter(func(x): return not x.is_fainted) as Array[UnitModel]
		SkillBase.TargetFainted.NONE:
			return
	return

func get_skill(unit: UnitModel) -> SkillModel:
	if current_index >= unit.skills.size():
		return
	current_skill = unit.get_skill(current_index)
	return current_skill

func get_random_current_target() -> int:
	if group_targets_available.is_empty() or group_targets_available.size() <= 0:
		return 0
	var index: int = randi() % group_targets_available.size()
	return group_targets_available.find(group_targets_available[index])

func refesh():
	refactored_unslelcted_by_skill()

	current_index = 0
	current_skill = null
	current_target = 0
	current_target_filter = 0

	group_targets_available = []
	group_targets_available_filter = []
	group_targets_select = []

	state = State.START

func refactored_slelcted_by_skill():
	for unit in group_targets_select:
		unit.node.seleted_by_skill()
	for unit in group_targets_available:
		if unit not in group_targets_select:
			unit.node.unseleted_by_skill()

func refactored_unslelcted_by_skill():
	for unit in group_targets_available:
		unit.node.unseleted_by_skill()
	return
