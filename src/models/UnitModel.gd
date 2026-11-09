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

var is_player: bool = true

# Stats
var health: int
var mp: int
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
    stats_modified.set_stats() # Mặc định không tăng/giảm chỉ số nào

    health = max_health
    mp = max_mp

    for skill in _base.skills:
        if skill is SkillBase:
            skills.append(SkillModel.new(skill))
    pass

# Get
func get_stats(_stat: Stats.Type) -> int:
    var amount_base = stats_base.get_stats(_stat) * 1.0
    var amount_modified = stats_modified.get_stats(_stat) * 1.0
    return int(((amount_base + (amount_modified + amount_base)) / 100.0) * level)

func get_skill(index: int):
    if index >= skills.size() or index < 0:
        return
    return skills[index]

# Set

# Modify

# Check

# Action / Event

func take_damage(damage_model: DamageModel = null):
    if damage_model == null:
        return false
    damage_model.resolve_against(self)
    BattleEvents.damage_before.emit(damage_model)

    damage_model.hp_before = health
    set_hp_by_damage(damage_model.get_damage())
    damage_model.hp_after = health
    damage_model.damage_dealt = damage_model.hp_before - health
    damage_model.is_lethal = is_fainted

    BattleEvents.damage_after.emit(damage_model)
    return

func set_hp_by_damage(value: int):
    health = max(0, min(max_health, health - value))
    if health <= 0:
        is_fainted = true
    return