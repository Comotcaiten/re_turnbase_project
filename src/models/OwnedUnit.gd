class_name OwnedUnit

const MAX_LEVEL := 100

var base: UnitBase
var level: int
var items: Array[ItemBase] = []

func _init(_base: UnitBase, _level: int = 1):
	base = _base
	level = clampi(_level, 1, MAX_LEVEL)

func level_up() -> bool:
	if level >= MAX_LEVEL:
		return false
	level += 1
	return true

func get_item_cost() -> int:
	var total: int = 0
	for item in items:
		total += item.cost
	return total

func can_equip(item: ItemBase) -> bool:
	return item != null and items.size() < UnitModel.MAX_ITEM_SLOTS and get_item_cost() + item.cost <= UnitModel.MAX_ITEM_COST

func equip(item: ItemBase) -> bool:
	if not can_equip(item):
		return false
	items.append(item)
	return true

func unequip_at(index: int) -> bool:
	if index < 0 or index >= items.size():
		return false
	items.remove_at(index)
	return true

# Model để xem chỉ số đã tính cả cấp và item
func to_unit_model() -> UnitModel:
	var model := UnitModel.new(base, level)
	for item in items:
		model.equip_item(item)
	return model

func to_unit_node() -> UnitNode:
	var unit_node := UnitNode.new()
	unit_node.base = base
	unit_node.level = level
	unit_node.items = items.duplicate()
	return unit_node
