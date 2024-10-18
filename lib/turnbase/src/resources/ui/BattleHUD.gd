extends Node
class_name BattleHUD

@export var hp_bar: HPBar
@export var hp_label: Label
@export var name_label: Label

var unit: UnitModel

var hp_normalized: int:
  get:
    return int(((unit.hp * 1.0) / (unit.max_hp * 1.0)) * 100.0)

func set_data(_unit: UnitModel):
  unit = _unit
  
  if name_label != null:
    name_label.text = unit.base.name
  else:
    name_label.text = "<Null>"
  
  update_hp()

func update_hp():
  hp_bar.set_hp(hp_normalized)
  if hp_label != null:
    hp_label.text = str(unit.hp) + "/" + str(unit.max_hp)
  else:
    hp_label.text = "<Null>"