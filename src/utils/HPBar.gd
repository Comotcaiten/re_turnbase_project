extends Node

class_name HPBar

@export var progress_bar: ProgressBar

@export var unit: UnitModel

func update_hp():
  if unit == null:
    return
  progress_bar.value = int(((unit.health * 1.0) / max(1.0, unit.max_health * 1.0) * 100.0))