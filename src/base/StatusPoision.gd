extends  StatusBase

class_name StatusPoision

func _on_start(_unit: UnitModel) -> bool:
    # example
    # unit.status_time = randi_range(1,4)
    var poision_time = randi_range(1,4)
    print("On Start: ", poision_time)
    return true

# call after unit use skill
func _on_after_move(_unit: UnitModel) -> bool:
    print("On After Move")
    return true

# call before unit use skill
func _on_before_move(_unit: UnitModel) -> bool:
    # example
    # if unit.status_time <= 0:
        # unit.cure_status
    
    # unit.status_time -= 1

    print("On Before Move")
    return true