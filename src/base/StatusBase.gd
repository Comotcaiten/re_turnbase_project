class_name StatusBase

var name: String
var description: String
var start_message: String
var time: int:
    get:
        return max(0, time)
var color: Color

func _init(_name: String = "", _description: String = "", _start_message: String = "", _time: int = 1):
    name = _name
    description = _description
    start_message = _start_message
    time = _time
    pass

func install(_json: Dictionary = {}):
    var _name = _json.get("name")
    var _description = _json.get("description")
    var _start_message = _json.get("start_message")
    var _time = _json.get("time")

    if _name is String and _name != null:
        name = _name
    if _description is String and _description != null:
        description = _description
    if _start_message is String and _start_message != null:
        start_message = _start_message
    if _time is int and _time != null:
        time = _time
    pass

func _on_start(_unit: UnitModel) -> bool:
    # example
    # unit.status_time = randi_range(1,4)
    return true

# call after unit use skill
func _on_after_move(_unit: UnitModel) -> bool:
    return true

# call before unit use skill
func _on_before_move(_unit: UnitModel) -> bool:
    # example
    # if unit.status_time <= 0:
        # unit.cure_status
    
    # unit.status_time -= 1

    return true