extends Node
class_name BattleSystemController

enum State {Start, CharacterTurn, SkillChoice, End}

@export var unit_combatant_player: UnitCombatantController
@export var unit_combatant_enemy: UnitCombatantController

var player_unit: UnitModel

var unit_combatants: Array[UnitModel]
var player_combatants: Array[UnitModel]:
	get:
		return unit_combatant_player.get_all_unit()
var enemy_combatants: Array[UnitModel]:
	get:
		return unit_combatant_enemy.get_all_unit()

var current_queue: int

var state: State

var current_skill: int

var count_cycle: int

var first_choice_target: bool = true

var enemy_unit_choice: UnitModel

var current_target: int

func _ready():
	initialize()
	print(unit_combatants)
	pass

func _process(_delta):
	match state:
		State.Start:
			perform_state_start()
		State.CharacterTurn:
			perform_state_character()
		State.SkillChoice:
			perform_state_skill_choice()
		State.End:
			perform_state_end()
	pass

func initialize():
	unit_combatant_player.initialize()
	unit_combatant_enemy.initialize()

	sort_combined_queue()
	
	state = State.Start

func sort_by_speed(a: UnitModel, b: UnitModel):
	return a.stats_controller.speed > b.stats_controller.speed

func update_turn_order():
	unit_combatants.sort_custom(sort_by_speed)

func sort_combined_queue():
	var players = unit_combatant_player.childs
	var enemys = unit_combatant_enemy.childs
	unit_combatants = players + enemys
	update_turn_order()
	pass

func reset_cycle():
	count_cycle += 1
	current_queue = -1
	sort_combined_queue()
	perform_next_turn()

func filter_is_not_fainted(a: UnitModel):
	return a.is_fainted

# Hàm kiểm tra xem tất cả các unit không phải player có ngã hay không
func all_units_enemy_fainted() -> bool:
	for _unit in unit_combatants:
		if not _unit.is_fainted and not _unit.is_player:
			return false
	return true

# Hàm kiểm tra xem tất cả các unit player có ngã hay không
func all_units_player_fainted() -> bool:
	for _unit in unit_combatants:
		if not _unit.is_fainted and _unit.is_player:
			return false
	return true

# # <Perform State>
func perform_next_turn():
	if all_units_enemy_fainted() or all_units_player_fainted():
		# Kiểm tra nếu tất cả các unit không phải người chơi đã ngã
		state = State.End # Cập nhật trạng thái thành End
		return

	print("[Next turn] ", current_queue)
	# current_queue += 1

	while unit_combatants[current_queue].is_fainted:
		current_queue += 1

	if current_queue >= unit_combatants.size():
		reset_cycle()
		return

	var current_unit = unit_combatants[current_queue]
	print("[Next turn] Unit next turn: ", current_unit.name)
	current_unit.speed_changed = false # Reset lại flag tốc độ

	# if !current_unit.is_player:
	# 	player_unit = current_unit
	# else:
	# 	player_unit = null
	state = State.CharacterTurn
	return

func perform_state_start():
	state = State.CharacterTurn

func perform_state_character():
	print("[Perform Character]: ", unit_combatants[current_queue].name)
	var current_unit = unit_combatants[current_queue]

	if current_unit.is_player:
		state = State.SkillChoice
		player_unit = current_unit
		return
	else:
		print("Enemy đi lượt này")
		player_unit = null
		var skill = current_unit.get_random_skill()
		var unit_random = get_random_unit()
		perform_run_skill(unit_random, current_unit, skill)
	return

func perform_state_skill_choice():
	perform_select_target()

	if Input.is_action_just_pressed("ui_action_1"):
		print("[UI Input] Q - 1")
		set_current_skill(0)
	if Input.is_action_just_pressed("ui_action_2"):
		print("[UI Input] W - 2")
		set_current_skill(1)
	if Input.is_action_just_pressed("ui_action_3"):
		print("[UI Input] E - 3")
		set_current_skill(2)
	if Input.is_action_just_pressed("ui_action_4"):
		print("[UI Input] R - 4")
		set_current_skill(3)
	
	if Input.is_action_just_pressed("ui_accept"):
		var skill = player_unit.get_skill_by_id(current_skill)
		perform_next_turn()
		print("[Perform Action Skill]", player_unit.name, " use skill on ", unit_combatants[current_target].name)
		perform_run_skill(unit_combatants[current_target], player_unit, skill)
	pass

func perform_state_end():
	pass
# # </Perform State>

# <Target>
func perform_select_target():
	if Input.is_action_just_pressed("ui_right"):
		current_target += 1
		if current_target >= unit_combatants.size():
			current_target = 0
		perform_info_target()
		print("[UI RIGHT] ", current_target)
			
	if Input.is_action_just_pressed("ui_left"):
		current_target -= 1
		if current_target < 0:
			current_target = unit_combatants.size() - 1
		print("[UI LEFT] ", current_target)
		perform_info_target()
	return

func perform_info_target():
	# print(unit_combatants)
	print("[Perform info target] Target: ", unit_combatants[current_target].name)

func get_random_unit():
	return unit_combatants[randi() % unit_combatants.size()]
# </Target>

# <Skill>
func perform_run_skill(_target: UnitModel, _source: UnitModel, _skill: SkillModel):
	print("[Perform run skill] ")
	if _skill == null or _target == null or _source == null:
		perform_next_turn()
		return

	_source.use_skill(_target, _skill)

	if _target.speed_changed:
		update_turn_order()
	
	current_skill = 0
	enemy_unit_choice = null

	update_hp()

	perform_next_turn()
	pass

func perform_get_info_skill():
	print("[Current] ", unit_combatants[current_queue].name, " - Player: ", player_unit.name)
	print("[Skills]: ", player_unit.get_skill_by_id(current_skill).base.name)

func set_current_skill(_value: int):
	if player_unit == null:
		print("[Skills]: Player unit null: ", player_unit)
		return
	var size = player_unit.get_skills().size()
	if _value >= size:
		print("[Skills]: value >= size")
		return
	current_skill = _value
	perform_get_info_skill()
# </Skill>

# <Update>
func update_hp():
	print("[----------------------------------------]")
	for _unit in unit_combatants:
		print("[", _unit.name, "] HP: ", _unit.stats_controller.health, "/", _unit.stats_controller.max_health)
	print("[----------------------------------------]")
# </Update>