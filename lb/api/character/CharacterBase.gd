# CharacterBase.gd
extends Resource
class_name CharacterBase

# Attribute - Thuộc tính - Chỉ số của nhân vật như máu
enum Attribute {Hp, Mp, Attack, Defense, Speed, Crit}
# Nguyên tố - Hệ - Sức mạnh nguyên tố / hệ của nhân vật
enum Element {None, Physical, Fire, Water}

# Thông tin - Chỉ số cơ bản của nhân vật
@export var name: String
@export var element: Element
@export var hp: int
@export var mp: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var crit: int

@export var skillLearables: Array[SkillLearnable]