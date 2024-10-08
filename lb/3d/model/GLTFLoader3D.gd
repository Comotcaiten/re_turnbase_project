extends Node

@export var model_path: String

var model_instance: MeshInstance3D

func _ready():
    load_model()

func load_model():
    var result = load(model_path)
    if result:
        model_instance = MeshInstance3D.new()
        model_instance.mesh = result
        add_child(model_instance)
    else:
        print("Failed to load model.")
