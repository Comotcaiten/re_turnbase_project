class_name UnitInstaceModel
extends Node

var base: UnitBaseModel = UnitBaseModel.new()
var name_override: String = "Unanem"
var level: int
var element: Utils.Element = Utils.Element.PHYSICAL

# Container/Model/Node
# @export var sprite: Sprite2D

# StatsModel
var stats_base: StatsModel = StatsModel.new()

# stats
var max_health: int
var health: int = 1
var attack: int
var defense: int 

# Dữ liệu level scaling của các chỉ số ứng với level
const LEVEL_SCALING = {
	Utils.Stats.HP: 10.0,
	Utils.Stats.ATTACK: 2.5,
	Utils.Stats.DEFENSE: 3.0,
}

func _init(_base: UnitBaseModel = null, _level: int = 1):

  # if _base == null:
  #   base = UnitBaseModel.new()
  #   level = _level
  #   element = Utils.Element.PHYSICAL
  #   name = "Uname"
  #   stats_base = StatsModel.new()
  # else:
  base = _base
  level = _level
  element = _base.element
  name_override = _base.name
  stats_base = base.stats

  health = max_health
  pass

# Get

# func get_stats(stat: Utils.Stats) -> int:
#   # var base_value: float = max(0.0, stats_base.get(stat, 1.0) * 1.0)
#   # var scaling: float = LEVEL_SCALING.get(stat, 5.0)
#   # var final_value = base_value + (level * scaling)
#   # return clamp(int(final_value), 1, 9999) # Giới hạn từ 1 đến 9999

# Set
