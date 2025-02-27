# UnitBaseRepository.gd
extends Node
class_name UnitBaseRepository

var unit_bases: Dictionary = {}

func _ready() -> void:
	preload_unit_bases()

func preload_unit_bases() -> void:
	unit_bases = {
		"dragon": preload("res://asset/units/dragon.tres"),
		"knight": preload("res://asset/units/knight.tres"),
		"mage": preload("res://asset/units/mage.tres"),
		"skeleton": preload("res://asset/units/sekeleton.tres"),
	}
	print("Loaded unit bases: ", unit_bases)

func get_unit_base(key: String) -> UnitBaseModel:
	if unit_bases.has(key):
		return unit_bases[key]
	else:
		push_warning("Unit base not found for key: " + key)
		return null
