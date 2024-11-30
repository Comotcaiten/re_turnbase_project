extends Node
class_name LevelTestSystem

@export var unit_model_test: UnitModel

func _ready():
  var damage: DamageDetailModel = DamageDetailModel.new(100, DamageDetailModel.TypeAttack.Physical, false, CharacterBase.Element.Physical, unit_model_test)
  unit_model_test.get_damage(damage, unit_model_test)
  pass

func _process(_delta):
  pass