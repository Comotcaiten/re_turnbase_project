extends Node

@export var model: ModelBlockBench

func _ready():
  set_up()
  pass

func _process(_delta: float):
  if Input.is_action_just_pressed("ui_accept"):
    print("[>] Action")
    model.run_animation("fight")

func set_up():
  if model != null:
    model.set_up()