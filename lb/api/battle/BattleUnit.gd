extends Node
class_name BattleUnit

@export var base: CharacterBase
@export var level: int:
	get:
		if level < 0:
			return 0
		return level
@export var isPlayerUnit: bool

@export var hud: BattleHUD

var character: Character

func SetUp():
	character = Character.new(base, level)
	# hud.SetData(character)
	print("-----<BattelUnit SetUp>-----")
	character.PrintStat()
	character.PrintSkill()
	character.CheckTypeSkill(character.skills[0])
	# hud.SetData(character)
	print("-----</BattelUnit SetUp>-----")
