extends Node3D
class_name ModelBlockBench

@export var model: PackedScene # GLTF model resource

@onready var blockbench_export = $point/blockbench_export
@onready var point = $point

var child_model_point

func _ready():
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
        child_model_point = instance

        print("[>] Exist: ", blockbench_export)
        print("[>] Model loaded successfully.")
    else:
        print("[>] Failed to load the model. (Please check model and blockbench_export in point)")
