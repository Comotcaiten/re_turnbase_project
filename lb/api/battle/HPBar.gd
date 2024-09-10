extends Node
class_name HPBar

@export var hpBar: ProgressBar

func SetHP(hpNormalized: int):
	self.value = hpNormalized

const EPSILON = 0.0001

var getDelta
func _process(delta):
	getDelta = delta

func SetHPSmooth(newHP: float):
	var curValue = self.value
	var changeAmt = curValue - newHP
	while (curValue - newHP) > EPSILON:
		curValue -= changeAmt * getDelta
		self.value = curValue
	return
