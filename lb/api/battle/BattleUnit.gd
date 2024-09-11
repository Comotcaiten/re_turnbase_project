extends Node
class_name BattleUnit

@export var base: CharacterBase
@export var level: int:
	get:
		return max(level, 0)
@export var weapon: ItemzBase

@export var isPlayerUnit: bool

# @export var hud: BattleHUD

var character: Character

func SetUp():
	character = Character.new(base, level)
	EquipmentItemForHand(weapon)
	# hud.SetData(character)
	print("-----<BattelUnit SetUp>-----")
	character.PrintAttribute()
	character.PrintSkill()
	# hud.SetData(character)
	print("-----</BattelUnit SetUp>-----")

func EquipmentItemForHand(_weapon: ItemzWeaponBase):
	character.EquipmentItemForHand(_weapon)