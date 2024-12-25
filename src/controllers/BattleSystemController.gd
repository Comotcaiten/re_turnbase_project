extends Node
class_name BattleSystemController

enum State {StartState, StartCycleState, UnitTurnState, ActionState, SkillState, EndCycleState, EndState}

# -------------------------------------------------------------------------------------
var skill_sytem_controller: SkillSystemController = SkillSystemController.new(self)

@export var player_unit_group_model: UnitGroupModel
@export var enemy_unit_group_model: UnitGroupModel


@export var label_count_cycle: Label
@export var lable_state: Label
@export var lable_action: Label
@export var label_turn: Label

@export var vbox_container_db: VBoxContainer

var db_groups_unit: Maps = Maps.new()

var db_label: Maps = Maps.new()

# all_unit: Chứa tất cả unit bao gồm cả những unit bị fainted
# var all_unit: Array[UnitModel]:
# 	get:
# 		return player_unit_group_model.group + enemy_unit_group_model.group
# turn_queue: Chứa các unit chưa bị fainted và sắp xếp chúng để thực hiện hành động theo lượt ở từng cycle
var turn_queue: Array[UnitModel]:
	get:
		return get_turn_queue(player_unit_group_model.group, enemy_unit_group_model.group)

var state: State

var current_queue: int
var current_action: int
var current_skill: int
var count_cycle: int
var is_end: bool = false

@export var max_cycle: int = 10

var current_unit: UnitModel:
	get:
		return turn_queue[current_queue]
# -------------------------------------------------------------------------------------

func _ready():
	skill_sytem_controller = SkillSystemController.new(self)

	db_groups_unit.add_val(player_unit_group_model.id, player_unit_group_model)
	db_groups_unit.add_val(enemy_unit_group_model.id, enemy_unit_group_model)


	start_lable()
	pass

func _process(_delta):
	if (player_unit_group_model == null) or (enemy_unit_group_model == null):
		return
	match state:
		State.StartState:
			perform_start_state()
		State.StartCycleState:
			update_label()
			perform_start_cycle_state()
		State.UnitTurnState:
			update_label()
			perform_unit_turn_state()
		State.ActionState:
			update_label()
			perform_action_state()
		State.SkillState:
			update_label()
			perform_skill_state()
		State.EndCycleState:
			update_label()
			perform_end_cycle_state()
		State.EndState:
			update_label()
			perform_end_state()
	return

# Cycle
func reset_cycle():
	current_queue = 0
	state = State.StartCycleState
	pass
	
# State
func perform_start_state():
	print("<<<<<<<<<<<< Start GAME >>>>>>>>>>>>>>")
	state = State.StartCycleState
	pass

func perform_start_cycle_state():
	state = State.UnitTurnState
	pass

func perform_unit_turn_state():
	if turn_queue[current_queue].is_fainted == true:
		get_next_turn()
		return

	if turn_queue[current_queue].is_player:
		print("[Player]")
		state = State.ActionState
	else:
		# Nếu không phải player thì thực hiện các hành động
		print("[Enemy]")
		# state = State.EndState
		# get_next_turn()
		skill_sytem_controller.perfrom_random_skill(current_unit)
	return

func perform_action_state():
	state = State.SkillState
	pass

func perform_skill_state():
	skill_sytem_controller.perform_skill(current_unit)
	pass

func perform_after_every_thing():
	get_next_turn()
	return

func perform_end_cycle_state():
	if !(max_cycle <= 0) and (count_cycle >= max_cycle):
		state = State.EndState
		return
	
	# Check xem các tất cả unit của các group có bị fainted hết không
	is_units_group_fainted()

	count_cycle += 1
	reset_cycle()
	return

func perform_end_state():
	if !is_end:
		print("<<<<<<<<<<<< END GAME >>>>>>>>>>>>>>")
		is_end = true
	return

# TurnQueue
func is_units_group_fainted() -> bool:
	for values in db_groups_unit.db.values():
		if values.is_fainted():
			state = State.EndState
			return true
	return false

func get_next_turn():
	if is_units_group_fainted():
		return
	# index
	current_queue += 1

	if current_queue < 0:
		current_queue = turn_queue.size() - 1
	elif current_queue >= turn_queue.size():
		current_queue = 0

	state = State.UnitTurnState
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
	
# Skill

# Label
func start_lable():
	label_count_cycle.text = str(count_cycle)
	lable_state.text = State.find_key(state)
	label_turn.text = "Who?"

	for db in db_groups_unit.db:
		for unit in db_groups_unit.get_val(db).get_units():
			print(unit)
			var lb: Label = Label.new()
			lb.text = unit.name + ": " + str(unit.health) + "/" + str(unit.max_health)
			db_label.add_val(unit, lb)
			vbox_container_db.add_child(lb)

func update_label():
	label_count_cycle.text = str(count_cycle)
	lable_state.text = State.find_key(state)
	label_turn.text = current_unit.name

	for id in db_label.db.keys():
		if db_label.get_val(id) is Label:
			db_label.get_val(id).text = id.name + ": " + str(id.health) + "/" + str(id.max_health)