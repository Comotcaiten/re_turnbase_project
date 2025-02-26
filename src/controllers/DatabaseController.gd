class_name DatabaseController
extends Control

const units_base: Dictionary = {
			"dragon": preload("res://asset/units/dragon.tres"),
			"knight": preload("res://asset/units/knight.tres"),
			"mage": preload("res://asset/units/mage.tres"),
			"skeleton": preload("res://asset/units/sekeleton.tres")
		}

func _ready() -> void:
	print("Load Data units_base: ", units_base)
