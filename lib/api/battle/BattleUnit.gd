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

@export_group("Model")
@export var model3D: ModelBlockBench

var character: Character

func SetData(_base: CharacterBase, _Level: int):
	base = _base
	level = _Level

func SetUp():
	character = Character.new(base, level)
	# EquipmentItem()
	# character.AddItem(slot1)

	print("-----<BattelUnit SetUp>-----")
	hud.SetData(character)
	print("-----</BattelUnit SetUp>-----")

func SetUpOnlyCharacter():
	character = Character.new(base, level)
	PrintCharacter()

func SetModel3D():
	if base.model3D == null:
		return false
	print(base.model3D)
	model3D.set_up(base.model3D)
	return true

func EquipmentItem():
	for _item in [slot1, slot2, slot3, slot4, slot5]:
		character.EquipItem(_item)
	EquipMainHand()

func EquipMainHand():
	character.EquipMainHand(mainHand)

func PrintCharacter():
	if character == null:
		print("[!] Chưa có dữ liệu")
	character.PrintAttribute()
	character.PrintSkill()
	character.PrintItemEquiped()

# Run
func RunAnimation3D(_name: String) -> int:
	return model3D.run_animation(_name)