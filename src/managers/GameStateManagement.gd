class_name GameStateManagement

enum State {START, UNITTURN, SELECTACTION, SELECTSKILL, END}

var game_manager: GameManager

var state: State

func _init(_game_manager: GameManager = null):
    game_manager = _game_manager
    pass

func play() -> void:
    match state:
        State.START:
            start()
        State.UNITTURN:
            unit_turn()
        State.SELECTACTION:
            select_action()
        State.SELECTSKILL:
            select_skill()
        State.END:
            end()
    pass

func start():
    state = State.UNITTURN

func unit_turn():
    pass

func select_action():
    pass

func select_skill():
    pass

func end():
    pass