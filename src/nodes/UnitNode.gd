extends Resource

class_name UnitNode

@export var base: UnitBase
@export var level: int = 1:
  get():
    return max(1, level)
@export var is_player: bool = true