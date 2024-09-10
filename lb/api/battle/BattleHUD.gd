extends Node
class_name BattleHUD

@export var hpBar: HPBar
@export var lable: Label

var character: Character

var hpNormalized:
	get:
		return (character.hp * 1.0) / (character.max_hp * 1.0) * 100.0

func SetData(_character: Character):
	self.character = _character
	lable.text = character.nameCharacter
	print(character.nameCharacter, " (|) ")
	hpBar.SetHP(hpNormalized)

func UpdateHP():
	hpBar.SetHP(hpNormalized)

# func UpdateHPSmoot():
# 	hpBar.SetHPSmooth(hpNormalized)
