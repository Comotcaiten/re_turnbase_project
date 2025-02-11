extends Resource

class_name UnitBase

@export var name: String = "Undefined Unit"
@export var icon: Texture2D = Texture2D.new()
@export var element: Element.Type = Element.Type.PHYSICAL
@export var stats_base: StatsBase = StatsBase.new(true)