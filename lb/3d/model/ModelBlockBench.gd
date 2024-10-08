extends Node3D
class_name ModelBlockBench

@export var model: Resource # GLTF model resource

@onready var blockbench_export = $point/blockbench_export
@onready var point = $point

func _ready():
    if model == null or blockbench_export == null:
        print("[>] Model blockbench is Null")
    else:
        load_model(model)

func load_model(_model: Resource):
    var instance = _model.instantiate()
    
    print("[>] Instance: ", instance)
    print("[>] Exist: ", blockbench_export)

    if instance or blockbench_export:
        print("[>] Load: Start")

        instance.position = blockbench_export.position
        instance.rotation = blockbench_export.rotation

        point.add_child(instance)
        point.remove_child(blockbench_export)

        print("[>] Exist: ", blockbench_export)
        print("[>] Model loaded successfully.")
    else:
        print("[>] Failed to load the model.")
