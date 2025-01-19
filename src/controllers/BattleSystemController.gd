extends Node
class_name BattleSystemController

enum State {StartState, UnitTurnState, ActionState, SkillState, EndState}

@export var color: Color

@export var player_unit_group_model: UnitGroupController
@export var enemy_unit_group_model: UnitGroupController

@export var skill_sytem: SkillSystemController

@export var vbox: VBoxContainer

@export var max_object: int = 20:
	get:
		return max(1, max_object)

@export var button_skills: Array[Button]

var maps_unit_groups_controller: Maps = Maps.new(typeof("String"), typeof(UnitGroupController))
var maps_unit_label: Maps = Maps.new(typeof(UnitModel), typeof(Label))

var unit_group_size: int:
	get:
		# Đang tính cả các unit bị fainted
		return maps_unit_groups_controller.get_value(enemy_unit_group_model.id).unit_group.size() + maps_unit_groups_controller.get_value(player_unit_group_model.id).unit_group.size()

var state: State

var turn_queue: Array[UnitModel]:
	get:
		return get_turn_queue()

var current_queue: int
var current_action: int
var current_unit: UnitModel:
	get:
		return turn_queue[current_queue]

var scen = preload("res://asset/tres/unit_model.tscn")

#---------------------------------------------------------------------------------------------------

func _ready():
	print("BattleSystemController is ready")
	maps_unit_groups_controller.add(player_unit_group_model.id, player_unit_group_model)
	maps_unit_groups_controller.add(enemy_unit_group_model.id, enemy_unit_group_model)
	
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			for unit in value.unit_group:
				if unit is UnitModel:
					maps_unit_label.add(unit, Label.new())
	
	if vbox is VBoxContainer and vbox != null:
		print("VBoxContainer is not null")
		for value in maps_unit_label.get_all_values():
			if value is Label:
				vbox.add_child(value)
	else:
		print("VBoxContainer is null")
	
	update_unit_label()
	
	# for group in maps_unit_groups_controller.get_all_values():
	# 	if group is UnitGroupController:
	# 		group.update_position(20)
	pass

func _process(_delta):
	# skill_sytem.perform_skill_random(current_unit, self)

	match state:
		State.StartState:
			perform_start_state()
		State.UnitTurnState:
			perform_unit_turn_state()
		State.ActionState:
			perform_action_state()
		State.SkillState:
			perform_skill_state()
		State.EndState:
			perform_end_state()
	
	# if Input.is_action_just_pressed("ui_accept"):
	# 	if (unit_group_size) >= max_object:
	# 		print("Max object")
	# 		return
	# 	var base_unit: CharacterBase = CharacterBase.new()
	# 	var instance = scen.instantiate()
	# 	if !instance.initialize(base_unit, 10):
	# 		return
	# 	maps_unit_groups_controller.get_value(enemy_unit_group_model.id).add_unit(instance)
	# 	var value = Label.new()
	# 	maps_unit_label.add(instance, value)
	# 	vbox.add_child(value)

	# 	update_unit_label()
	return

func perform_start_state():
	state = State.UnitTurnState

	print("[Turn queue]", turn_queue)
	return

func perform_unit_turn_state():
	# if current_queue >= turn_queue.size():
	# 	current_queue = 0
	# 	state = State.ActionState
	# 	return
	if state == State.EndState:
		return
	current_unit = turn_queue[current_queue]

	if current_unit.is_player:
		print("Player turn: ", current_unit.name)
		state = State.ActionState
	else:
		print("Enemy turn: ", current_unit.name)
		skill_sytem.perform_random_skill()
	return

func perform_action_state():
	state = State.SkillState
	return

func perform_skill_state():
	skill_sytem.perform_skill()
	return

func perform_end_state():
	return

func get_next_turn():
	update_unit_label()
	# First: Check if one group units are fainted
	if is_one_group_units_fainted():
		return

	# Second: Update turn queue
	current_queue += 1
	if current_queue >= turn_queue.size():
		current_queue = 0
	
	# Third: Update state
	state = State.UnitTurnState
	return
#---------------------------------------------------------------------------------------------------

# TurnQueue và Quản lý các unit trong các Array[UnitModel]
func get_turn_queue_merge_and_cut(_group: Array[UnitModel] = []) -> Array[UnitModel]:
	var n = _group.size()
	# Gộp mảng với chính nó
	_group += _group

	# Lấy mảng với độ dài n + 1
	return _group.slice(0, n + 1)

func get_turn_queue() -> Array[UnitModel]:
	if maps_unit_groups_controller.is_empty():
		return []

	var _group: Array[UnitModel] = []
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			_group.append_array(value.unit_group)
	_group = get_turn_queue_merge_and_cut(_group)
	_group = UnitGroupController.get_static_units_by_state(false, _group)
	_group = UnitGroupController.get_groups_sort(_group)
	return _group

func get_info_units():
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			for unit in value.unit_group:
				print(unit)
				unit.print_stat()

func get_array_unit_group() -> Array[UnitGroupController]:
	var _group: Array[UnitGroupController] = []
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			_group.append(value)
	return _group

func get_array_unit_group_by_team(_team: int) -> Array[UnitGroupController]:
	var _group: Array[UnitGroupController] = []
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			if value.team == _team:
				_group.append(value)
	return _group

func get_all_units() -> Array[UnitModel]:
	var _group: Array[UnitModel] = []
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			_group.append_array(value.unit_group)
	
	print("Groups get all: ", _group)
	return _group

func update_turn_queue():
	turn_queue = UnitGroupController.get_static_units_by_state(false, turn_queue)
	turn_queue = UnitGroupController.get_groups_sort(turn_queue)
	return

func is_one_group_units_fainted() -> bool:
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			if value.are_all_units_fainted():
				state = State.EndState
				print("One group units are fainted => END")
				return true
	return false

#--------------------------------------------------------------------------------

func update_unit_label():
	if maps_unit_label.is_empty():
		return
	for value in maps_unit_label.get_all_keys():
		if value is UnitModel:
			if value.is_fainted:
				maps_unit_label.get_value(value).text = value.name + " [Fainted]"
			else:
				maps_unit_label.get_value(value).text = value.name + " [HP: " + str(value.health) + "/" + str(value.max_health) + "]"
	return

#--------------------------------------------------------------------------------
# Button Skill

func _on_button1_skill_pressed() -> void:
	pass # Replace with function body.


func _on_button_skill_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_skill_3_pressed() -> void:
	pass # Replace with function body.


func _on_button_skill_4_pressed() -> void:
	pass # Replace with function body.
