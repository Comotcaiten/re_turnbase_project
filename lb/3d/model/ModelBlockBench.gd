extends Node3D
class_name ModelBlockBench

@export var model: Texture3DRD

@onready var op = $point/blockbench_export

func _init():
    if op == null:
        print("[>] Model blockbench is Null")
    pass