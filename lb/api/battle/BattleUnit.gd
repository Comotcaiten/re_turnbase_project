extends Node
class_name BattleUnit

@export var base: CharacterBase
@export var level: int:
	get:
		return max(level, 0)
@export var isPlayerUnit: bool
@export var hud: BattleHUD

@export_group("Weapon")
@export var mainHand: ItemzBase

@export_group("Equipment")
@export var slot1: ItemzBase
@export var slot2: ItemzBase
@export var slot3: ItemzBase
@export var slot4: ItemzBase
@export var slot5: ItemzBase

var character: Character

func SetUp():
	character = Character.new(base, level)
	EquipmentItem()
	character.AddItem(slot1)
	hud.SetData(character)
	print("-----<BattelUnit SetUp>-----")
	# PrintCharacter()
	hud.SetData(character)
	print("-----</BattelUnit SetUp>-----")

func EquipmentItem():
	for _item in [slot1, slot2, slot3, slot4, slot5]:
		character.EquipItem(_item)
	EquipMainHand()

func EquipMainHand():
	character.EquipMainHand(mainHand)

func PrintCharacter():
	if character == null:
		print("<?> Chưa có dữ liệu")
	character.PrintAttribute()
	character.PrintSkill()
	character.PrintItemEquiped()