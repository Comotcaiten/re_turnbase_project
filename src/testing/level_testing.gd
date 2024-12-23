extends Node
class_name LevelTestSystem

var db: Maps = Maps.new()

func _ready():
	var a = [1, 2, 3, 4, 5]
	var b = [5, 6, 7, 8]
	a.append_array(b)
	print(a)
	pass

# func _process(_delta):
#   pass
