### GameManagement.gd
extends Node

class_name BattleSystem

enum State {START, UNITTURN, AIACTION, SELECTSKILL, END}

@export var turn_controller: TurnController
@export var skill_controller: SkillController
@export var group_controller: UnitGroupController

@export var player_group: UnitGroupModel
@export var enemy_group: UnitGroupModel

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
	state = new_state

func handle_unit_turn():
	print("Player's turn.")
	# Logic to manage player's turn
	if turn_controller.current_unit in player_group.group:
		print("Player")
		change_state(State.SELECTSKILL)
		return
	print("Enemy")
	change_state(State.AIACTION)

func handle_ai_action():
	print("AI is thinking...")
	# Logic to manage AI's action

func handle_select_skill():
	print("Selecting skill...")
	# Logic for selecting skill or executing attack
	# change_state(State.END)

func handle_end():
	print("Battle ended.")
	is_game_over = true
