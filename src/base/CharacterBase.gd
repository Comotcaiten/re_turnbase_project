extends Resource
class_name CharacterBase

enum StatType {Health, Attack, Defense, Speed}

@export var name: String

@export var health: int
@export var attack: int
@export var defense: int
@export var speed: int

@export var skills: Array[SkillBase]

func get_stats():
    return {
        StatType.Health: max(0, health),
        StatType.Attack: max(0, attack),
        StatType.Defense: max(0, defense),
        StatType.Speed: max(0, speed),
    }

func get_stats_default():
    return {
        StatType.Health: 0,
        StatType.Attack: 0,
        StatType.Defense: 0,
        StatType.Speed: 0,
    }

func get_skills():
    print(skills)
    # for skill in skills:
    #     if skill == null:
    #         return
    return skills