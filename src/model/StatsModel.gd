class_name StatsModel
extends Resource

@export var health: int = 1
@export var attack: int = 1
@export var defense: int = 1
@export var speed: int = 1


var stats: Dictionary = {
    Utils.Stats.HP: health,
    Utils.Stats.ATTACK: attack,
    Utils.Stats.DEFENSE: defense,
    Utils.Stats.SPEED: speed
}

func _init(modified: bool = false):
    if modified:
        set_stats(Utils.Stats.HP, 0)
        set_stats(Utils.Stats.ATTACK, 0)
        set_stats(Utils.Stats.DEFENSE, 0)
        set_stats(Utils.Stats.SPEED, 0)
        return
    initilized()
    return

func initilized():
    stats = {
        Utils.Stats.HP: health,
        Utils.Stats.ATTACK: attack,
        Utils.Stats.DEFENSE: defense,
        Utils.Stats.SPEED: speed
    }
    return

func get_stats(stat: Utils.Stats) -> int:
    return stats.get(stat, 0)

func set_stats(stat: Utils.Stats, value: int):
    stats[stat] = value
    return