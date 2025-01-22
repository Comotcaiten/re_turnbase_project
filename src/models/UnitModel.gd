class_name UnitModel

var base: UnitBase

var name: String
var id: String
var level: int
var element: Element.Type

# Stats cơ bản
var stats_base: Stats
# Stats tăng/giảm phần trăm dựa trên stats cơ bản
var stats_modified: Stats = Stats.new()

var skills: Array[SkillModel]

var is_fainted: bool = false

# Stats
var max_health: int:
    get:
        return get_stats(Stats.Type.HP)
var max_mp: int:
    get:
        return get_stats(Stats.Type.MP)
var attack: int:
    get:
        return get_stats(Stats.Type.ATTACK)
var defense: int:
    get:
        return get_stats(Stats.Type.DEFENSE)
var speed: int:
    get:
        return get_stats(Stats.Type.SPEED)

func _init(_base: UnitBase, _level: int):
    base = _base
    name = _base.name
    level = _level
    element = _base.element
    stats_base = _base.stats

    for skill in _base.skills:
        if skill is SkillBase:
            skills.append(SkillModel.new(skill))
    pass

# Get
func get_stats(_stat: Stats.Type) -> int:
    var amount_base = stats_base.get_stats(_stat) * 1.0
    var amount_modified = stats_modified.get_stats(_stat) * 1.0
    return int(((amount_base + (amount_modified + amount_base)) / 100.0) * level)