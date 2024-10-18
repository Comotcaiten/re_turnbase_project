extends Node
class_name HPBar

@export var bar: ProgressBar

func set_data(hp_normalized: int):
  bar.value = hp_normalized