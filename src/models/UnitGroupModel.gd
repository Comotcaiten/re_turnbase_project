class_name UnitGroupModel

var is_player: bool
var units: Array[UnitModel] = []

func add_unit(unit: UnitModel) -> bool:
	if unit == null or unit in units:
		return false
	units.append(unit)
	return true

func remove_unit(unit: UnitModel):
	if unit == null or !unit in units:
		return false
	units.erase(unit)
	return true

func get_units() -> Array[UnitModel]:
	if units == null:
		return []
	return units