extends Resource

class_name Stats

enum Type {HP, MP, ATTACK, DEFENSE, SPEED}

@export var hp: int = 100
@export var mp: int = 50
@export var attack: int = 10
@export var defense: int = 5
@export var speed: int = 15

var db: Dictionary = {}

func _init():
    update_db()

func get_stats(_type: Type) -> int:
    if !db.has(_type):
        print("Warning: Invalid stat type requested - ", _type)
        return 0
    return db[_type]

func set_stats(_hp: int = 0, _mp: int = 0, _attack: int = 0, _defense: int = 0, _speed: int = 0) -> void:
    hp = _hp
    mp = _mp
    attack = _attack
    defense = _defense
    speed = _speed
    update_db()

func update_db() -> void:
    db = {
        Type.HP: hp,
        Type.MP: mp,
        Type.ATTACK: attack,
        Type.DEFENSE: defense,
        Type.SPEED: speed
    }