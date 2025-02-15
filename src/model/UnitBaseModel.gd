class_name UnitBaseModel
extends Resource

@export_group('Info')
@export var name: String
@export var element: Utils.Element

@export_group('Stats')
@export var health: int
@export var damage: int