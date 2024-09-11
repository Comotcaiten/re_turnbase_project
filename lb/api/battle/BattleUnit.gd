extends Node
class_name BattleUnit

@export var base: CharacterBase
@export var level: int:
	get:
		return max(level, 0)
@export var weapon: ItemzBase
@export var head: ItemzBase

@export var isPlayerUnit: bool

# @export var hud: BattleHUD

var character: Character

func SetUp():
	character = Character.new(base, level)
	# EquipmentHand(weapon)
	EquipmentItem(weapon, ItemzSlot.Type.Mainhand)
	EquipmentItem(head, ItemzSlot.Type.Head)
	# hud.SetData(character)
	print("-----<BattelUnit SetUp>-----")
	character.PrintAttribute()
	character.PrintSkill()
	character.PrintItemEquiped()
	# hud.SetData(character)
	print("-----</BattelUnit SetUp>-----")

func EquipmentHand(_weapon: ItemzWeaponBase):
	character.EquipmentItemForHand(_weapon)

func EquipmentItem(_item: ItemzBase, _slot: ItemzSlot.Type):
	character.EquipItem(_item, _slot)
