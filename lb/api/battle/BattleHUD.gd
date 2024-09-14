extends Node
class_name BattleHUD

@export var hpBar: HPBar
@export var hpLable: Label
@export var nameLable: Label

var character: Character

var hpNormalized:
	get:
		return (character.hp * 1.0) / (character.max_hp * 1.0) * 100.0

func SetData(_character: Character):
	self.character = _character
	if nameLable != null:
		nameLable.text = character.nameCharacter
	else:
		nameLable.text = "Null"
	if hpLable != null:
		hpLable.text = str(character.hp) + "/" + str(character.max_hp)
	hpBar.SetHP(hpNormalized)

func UpdateHP():
	hpBar.SetHP(hpNormalized)
	if hpLable != null:
		hpLable.text = str(character.hp) + "/" + str(character.max_hp)

# func UpdateHPSmoot():
# 	hpBar.SetHPSmooth(hpNormalized)
