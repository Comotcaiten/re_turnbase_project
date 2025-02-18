class_name UnitInstaceModel
extends Node

var base: UnitBaseModel = UnitBaseModel.new()
var name_override: String
var level: int
var element: Utils.Element

# Container/Model/Node
@export var sprite: Sprite2D

var stats_base: Dictionary = {}
# stats
var max_health: int:
  get:
    return get_stats(Utils.Stats.HP)
var health: int = 1
var attack: int:
  get:
    return get_stats(Utils.Stats.ATTACK)
var defense: int:
  get:
    return get_stats(Utils.Stats.DEFENSE)

# Dữ liệu level scaling của các chỉ số ứng với level
const LEVEL_SCALING = {
	Utils.Stats.HP: 10.0,
	Utils.Stats.ATTACK: 2.5,
	Utils.Stats.DEFENSE: 3.0,
}

func _init(_base: UnitBaseModel, _level: int):
  base = _base
  level = _level
  element = _base.element
  name = _base.name

  stats_base = {
    Utils.Stats.HP: base.health,
    Utils.Stats.ATTACK: base.attack,
    Utils.Stats.DEFENSE: base.defense,
  }

  health = max_health
  pass

# Get

func get_stats(stat: Utils.Stats) -> int:
  var base_value: float = max(0.0, stats_base.get(stat, 1.0) * 1.0)
  var scaling: float = LEVEL_SCALING.get(stat, 5.0)
  var final_value = base_value + (level * scaling)
  return clamp(int(final_value), 1, 9999) # Giới hạn từ 1 đến 9999

# Set
