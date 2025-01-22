extends Node

class_name GameManager

@export var array_gorup_unit_node: Array[UnitGroupNode] = []

var game_state_management: GameStateManagement = GameStateManagement.new(self)

var turn_management: TurnManagement = TurnManagement.new(self)

func _ready():
	set_up_group_unit_nodes()

	turn_management.set_up()

	print(turn_management.turn_queue)

	for unit in turn_management.turn_queue:
		print(unit, " : ", unit.unit_model.speed)
	
	turn_management.update()
	print(turn_management.turn_queue)

	pass

# func _process(delta):

# 	game_state_management.play()
# 	pass

func set_up_group_unit_nodes() -> void:
	for gorup_unit_node in array_gorup_unit_node:
		gorup_unit_node.set_up()