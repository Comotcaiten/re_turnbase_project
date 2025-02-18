class_name PlayerDB
extends Resource

@export var id: String = str(self).replace("<Resource#-", "").replace(">", "").replace("", "")
@export var unit_base_owns: Array[UnitBaseModel] = []

var unit_model_owns: Array[UnitInstaceModel] = []

func _init():
  id = str(self).replace("<Resource#-", "").replace(">", "").replace("", "")

  if unit_base_owns.size() > 0 and unit_model_owns.size() <= 0:
    for unit_base in unit_base_owns:
      unit_model_owns.append(UnitInstaceModel.new(unit_base, 1))
  pass

func add_unit(unit_base: UnitBaseModel) -> bool:
  if unit_base_owns.find(unit_base):
    return false

  var unit_model = UnitInstaceModel.new(unit_base, 1)

  unit_base_owns.append(unit_base)
  unit_model_owns.append(unit_model)

  return true

func get_units():
  return unit_model_owns