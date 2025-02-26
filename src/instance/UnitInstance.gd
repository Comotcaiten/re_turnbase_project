class_name UnitInstance
extends Resource

var base: UnitBaseModel
var level: int
var element: Utils.Element
var base_stats: StatsModel

var current_hp: int

var max_hp: int:
	get:
		return get_stats(Utils.Stats.HP)

var attack: int:
	get:
		return get_stats(Utils.Stats.ATTACK)

var defense: int:
	get:
		return get_stats(Utils.Stats.DEFENSE)

var speed: int:
	get:
		return get_stats(Utils.Stats.SPEED)

func _init(_base: UnitBaseModel, _level: int = 1) -> void:
	base = _base
	level = _level
	element = _base.element
	base_stats = _base.stats
	
	current_hp = max_hp

func get_stats(stat: Utils.Stats):
	var amount_base = base_stats.get_stats(stat) * 1.0
	return int(amount_base + (level * 5.0))

func set_current_hp(value: int):
	if value < 0:
		return
	if value > max_hp:
		value = max_hp
	current_hp = value
	return
