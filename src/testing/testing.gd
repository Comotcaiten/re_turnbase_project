extends Node2D

@export var bases: Array[CharacterBase]

func _ready():
    # print ("Sort by speed")
    # bases.sort_custom(sort_by_speed)
    # for i in range(0, bases.size()):
    #     print("[", i, "] ", bases[i].name, " - ", bases[i].speed)

    # print ("Sort by health")
    # bases.sort_custom(sort_by_health)
    # for i in range(0, bases.size()):
    #     print("[", i, "] ", bases[i].name, " - ", bases[i].health)
    pass

func sort_by_speed(a, b):
    return a.speed < b.speed
func sort_by_health(a, b):
    return a.health < b.health