### GameManagement.gd
extends Node

class_name BattleSystem

enum State {START, UNITTURN, AIACTION, SELECTSKILL, END}

@export var turn_controller: TurnController
@export var skill_controller: SkillController
@export var group_controller: UnitGroupController

@export var player_group: UnitGroupModel
@export var enemy_group: UnitGroupModel

# @export var icon_unit_in_battle: IconUnitInBattle

@export var icons_unit_in_battle: Array[IconUnitInBattle]

var map_icon_unit_in_battle: Maps = Maps.new(
	typeof(UnitModel),
	typeof(IconUnitInBattle)
)

var state: State

var is_game_over: bool = false

var all_group: Array[UnitModel]
func _ready():
	initialized()
	print("Game Management initialized.")

func _process(_delta):
	play()
	pass

func initialized():

	for icon_unit_in_battle in icons_unit_in_battle:
		icon_unit_in_battle.visible = false

	if turn_controller == null:
		turn_controller = TurnController.new()
	turn_controller.initialized(self)
	if skill_controller == null:
		skill_controller = SkillController.new()
	skill_controller.initialized(self)
	if group_controller == null:
		group_controller = UnitGroupController.new()
	group_controller.initialized(self)

	turn_controller.set_up()

	# icon_unit_in_battle.visible = false
	var group_is_player: Array[UnitModel] = group_controller.get_group_is_player().group
	for unit_index in range(0, group_is_player.size()):
		map_icon_unit_in_battle.add(group_is_player[unit_index], icons_unit_in_battle[unit_index])
		icons_unit_in_battle[unit_index].visible = true
		if group_is_player[unit_index].icon != null:
			icons_unit_in_battle[unit_index].icon.texture = group_is_player[unit_index].icon

func play():
	if turn_controller == null or skill_controller == null or group_controller == null:
		return
	if turn_controller.turn_queue.is_empty():
		return
	if is_game_over:
		return
	match state:
		State.START:
			print("Battle started!")
			print("Entering START state.")
			change_state(State.UNITTURN)
		State.UNITTURN:
			handle_unit_turn()
		State.AIACTION:
			handle_ai_action()
		State.SELECTSKILL:
			handle_select_skill()
		State.END:
			handle_end()

func change_state(new_state: State):
	if group_controller == null:
		state = State.END
		return
	if group_controller.is_one_group_fainted():
		state = State.END
		return
	state = new_state

func get_next_turn():
	if group_controller == null:
		return
	if group_controller.is_one_group_fainted():
		change_state(State.END)
		return
	if map_icon_unit_in_battle.has(turn_controller.current_unit):
		map_icon_unit_in_battle.get_value(turn_controller.current_unit).sprite_container.visible = false
	turn_controller.get_next_turn()
	change_state(State.UNITTURN)

func handle_unit_turn():
	print("Player's turn.")
	# Logic to manage player's turn
	if turn_controller.current_unit in player_group.group:
		print("Player")
		# icon_unit_in_battle.visible = true
		# if turn_controller.current_unit.icon != null:
		# 	icon_unit_in_battle.icon.texture = turn_controller.current_unit.icon
		map_icon_unit_in_battle.get_value(turn_controller.current_unit).sprite_container.visible = true
		change_state(State.SELECTSKILL)
		return
	print("Enemy")
	# icon_unit_in_battle.visible = false
	change_state(State.AIACTION)

func handle_ai_action():
	# print("AI is thinking...")
	# Logic to manage AI's action
	skill_controller.play(turn_controller.current_unit)

func handle_select_skill():
	# print("Selecting skill...")
	# Logic for selecting skill or executing attack
	skill_controller.play(turn_controller.current_unit)

func handle_end():
	print("Battle ended.")
	is_game_over = true
