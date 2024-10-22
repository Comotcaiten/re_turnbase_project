extends Node3D
class_name LoadModelBlockBench

@export var blockbench_export: Node3D
@export var point: Node3D

var data

var animation: AnimationPlayer

func set_data(_model: PackedScene) -> bool:
    if _model == null:
        print("[>] Model blockbench is Null, ")
        return false
    
    if blockbench_export == null:
        print("[>] Blockbench export is Null")
        return false

    if point == null:
        print("[>] Point is Null")
        return false

    load_model(_model)
    return true

func load_model(_model: Resource):
    # Init
    var instance = _model.instantiate()
    
    # print("[>] Instance: ", instance)
    # print("[>] Exist: ", blockbench_export)

    if instance and blockbench_export:
        # print("[>] Load: Start")

        # Ready
        instance.position = blockbench_export.position
        instance.rotation = blockbench_export.rotation

        # Replace
        point.remove_child(blockbench_export)
        point.add_child(instance)

        # Save point
        data = instance
        animation = data.get_child(1)

        # print("[>] Exist: ", blockbench_export)
        # print("[>] Animation: ", animation)
        # print("[>] Model loaded successfully.")
    else:
        print("[!] Failed to load the model. (Please check model and blockbench_export in point)")

func run_animation(_name: String) -> int:
    if _name == null or _name.is_empty():
        return 0
    var exist = animation.has_animation(_name)
    if exist:
        animation.play(_name)
    else:
        return 0
    return 1

func run_animation_debug(_name: String) -> int:
    if _name == null or _name.is_empty():
        return 0
    var exist = animation.has_animation(_name)
    # print("[>] Run animation ", _name)
    # print("[>] Get animation ", _name, ", ", exist)
    if exist:
        animation.play(_name)
    else:
        print("[!] Animation ", _name, " can not be found.")
        return 0
    return 1