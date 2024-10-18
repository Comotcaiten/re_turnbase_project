extends Resource
class_name CharacterBase

@export var name: String
@export var element: ElementBase.Type
@export var hp: int
@export var mp: int
@export var attack: int
@export var defense: int
@export var speed: int
@export var crit: int

@export var model3D: PackedScene

var attributes: Dictionary:
    get:
        return {
            AttributeBase.Type.None: 0,
            AttributeBase.Type.Hp: hp,
            AttributeBase.Type.Mp: mp,
            AttributeBase.Type.Attack: attack,
            AttributeBase.Type.Defense: defense,
            AttributeBase.Type.Speed: speed,
            AttributeBase.Type.Critical: crit,
            AttributeBase.Type.Others: 0
        }