extends Node3D
class_name ModelBlockBench

@export var model: PackedScene # GLTF model resource

@onready var blockbench_export = $point/blockbench_export
@onready var point = $point

var data

var animation: AnimationPlayer

func set_up():
    if model == null or blockbench_export == null:
        print("[>] Model blockbench is Null")
    else:
        load_model(model)

func load_model(_model: Resource):
    # Init
    var instance = _model.instantiate()
    
    print("[>] Instance: ", instance)
    print("[>] Exist: ", blockbench_export)

    if instance or blockbench_export:
        print("[>] Load: Start")

        # Ready
        instance.position = blockbench_export.position
        instance.rotation = blockbench_export.rotation

        # Replace
        point.remove_child(blockbench_export)
        point.add_child(instance)

        # Save point
        data = instance
        animation = data.get_child(1)

        print("[>] Exist: ", blockbench_export)
        print("[>] Animation: ", animation)
        print("[>] Model loaded successfully.")
    else:
        print("[>] Failed to load the model. (Please check model and blockbench_export in point)")

func run_animation(_name: String):
    if _name == null or _name.is_empty():
        return
    var exist = animation.has_animation(_name)
    print("[>] Run animation ", _name)
    print("[>] Get animation ", _name, ", ", exist)
    if exist:
        animation.play(_name)
    else:
        print("[>] Animation ", _name, " can not be found.")