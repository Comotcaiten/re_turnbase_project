class_name UnitBaseModel
extends Resource

@export_group('Info')
@export var name: String
@export var element: Utils.Element
@export var icon: Texture2D

@export_group('Stats')
@export var stats: StatsModel

func _init(_name: String = '', _element: Utils.Element = Utils.Element.PHYSICAL):
  name = _name
  element = _element
  pass
