extends SkillMechanic
class_name DamageMechanic

@export var power: int

func Apply(_target: Character) -> bool:
    _target.hp -= power
    if _target.hp <= 0:
        return true
    return false
