extends Resource

class_name ItemBase

@export var name: String
@export var id: String
@export_range(1, 4) var cost: int = 1

# Chỉ số cộng thẳng cho unit. Không dùng Stats vì Stats có giá trị mặc định khác 0
@export_group("Bonus")
@export var hp: int = 0
@export var mp: int = 0
@export var attack: int = 0
@export var defense: int = 0
@export var speed: int = 0

@export_group("Passives")
@export var passives: Array[Passive] = []

func get_bonus(_type: Stats.Type) -> int:
	match _type:
		Stats.Type.HP:
			return hp
		Stats.Type.MP:
			return mp
		Stats.Type.ATTACK:
			return attack
		Stats.Type.DEFENSE:
			return defense
		Stats.Type.SPEED:
			return speed
	return 0
