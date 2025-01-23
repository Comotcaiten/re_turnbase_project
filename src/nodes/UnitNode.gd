extends Node

class_name UnitNode

@export var base: UnitBase
@export var level: int = 1:
  get():
    return max(1, level)

var unit_model: UnitModel

func initialized():
  if base == null or level < 0:
    return false
  unit_model = UnitModel.new(base, level)
  return true