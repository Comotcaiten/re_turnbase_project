class_name OwnedUnit

const MAX_LEVEL := 100

var base: UnitBase
var level: int

func _init(_base: UnitBase, _level: int = 1):
	base = _base
	level = clampi(_level, 1, MAX_LEVEL)

func level_up() -> bool:
	if level >= MAX_LEVEL:
		return false
	level += 1
	return true

func to_unit_node() -> UnitNode:
	var unit_node := UnitNode.new()
	unit_node.base = base
	unit_node.level = level
	return unit_node
