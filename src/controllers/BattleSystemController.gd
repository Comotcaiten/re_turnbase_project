extends Node
class_name BattleSystemController

enum State {StartState, UnitTurnState, ActionState, SkillState, EndState}

@export var player_unit_group_model: UnitGroupController
@export var enemy_unit_group_model: UnitGroupController

var maps_unit_groups_controller: Maps = Maps.new(typeof("String"), typeof(UnitGroupController))
var maps_unit_label: Maps = Maps.new(typeof(UnitModel), typeof(Label))

var skill_sytem: SkillSystemController = SkillSystemController.new()

var state: State

var turn_queue: Array[UnitModel]:
	get:
		return get_turn_queue()

var current_queue: int
var current_action: int
var current_unit: UnitModel:
	get:
		return turn_queue[current_queue]


func _ready():
	maps_unit_groups_controller.add(player_unit_group_model.id, player_unit_group_model)
	maps_unit_groups_controller.add(enemy_unit_group_model.id, enemy_unit_group_model)
	pass

func _process(_delta):
	skill_sytem.perform_skill_random(current_unit, self)
	return

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
			_group.append_array(value.get_units())
	_group = get_turn_queue_merge_and_cut(_group)
	_group = UnitGroupController.get_units_by_state(false, _group)
	_group = UnitGroupController.get_groups_sort(_group)
	return _group

func get_info_units():
	for value in maps_unit_groups_controller.get_all_values():
		if value is UnitGroupController:
			for unit in value.get_units():
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
			_group.append_array(value.get_units())
	return _group

func update_turn_queue():
	turn_queue = UnitGroupController.get_units_by_state(false, turn_queue)
	turn_queue = UnitGroupController.get_groups_sort(turn_queue)
	return
