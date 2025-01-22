class_name TurnManagement

var game_manager: GameManager

var turn_queue: Array[UnitNode]

var current_unit: UnitModel:
    get:
        return turn_queue[current_index].unit_model

var current_index: int

func _init(_game_manager: GameManager = null):
    game_manager = _game_manager
    pass

func set_up():
    for group_unit_node in game_manager.array_gorup_unit_node:
        turn_queue.append_array(group_unit_node.group)

func add_unit_node(unit_node: UnitNode):
    if unit_node == null:
        return false
    if unit_node in turn_queue:
        return false
    
    turn_queue.append(unit_node)

func update():
    turn_queue.sort_custom(func(a, b):
        return a.unit_model.speed > b.unit_model.speed
)

func get_next_turn():
    pass