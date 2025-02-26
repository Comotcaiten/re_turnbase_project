# UnitFactory.gd
class_name UnitFactory
extends Node

var units_instance: Dictionary = {}

func _ready():
	load_units()
	pass

func load_units():
	for unit_data in SqlController.load_units():
		print(unit_data)
		var base: UnitBaseModel = Database.units_base[unit_data["base"]]
		var instance: UnitInstance = UnitInstance.new(base, unit_data["level"])
		instance.set_current_hp(unit_data['current_hp'])
		print("Base: ", base, " - Instance: ", instance)
		units_instance[base] = instance
