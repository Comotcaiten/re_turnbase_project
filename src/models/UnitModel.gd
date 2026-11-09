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

# Break
const BREAK_SPEED_MULTIPLIER := 0.5
const BREAK_DAMAGE_MULTIPLIER := 1.5

var max_break: int
var break_gauge: int
var is_broken: bool = false
var has_lost_turn: bool = false # Đã mất lượt trong lần bị break này chưa

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
    max_break = _base.max_break
    break_gauge = max_break

    for skill in _base.skills:
        if skill is SkillBase:
            skills.append(SkillModel.new(skill))
    pass

# Get
func get_stats(_stat: Stats.Type) -> int:
    var amount_base = stats_base.get_stats(_stat) * 1.0
    var amount_modified = stats_modified.get_stats(_stat) * 1.0
    var amount: int = int(((amount_base + (amount_modified + amount_base)) / 100.0) * level)
    if _stat == Stats.Type.SPEED and is_broken:
        return int(amount * BREAK_SPEED_MULTIPLIER)
    return amount

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
    reduce_break(damage_model)

    BattleEvents.damage_after.emit(damage_model)
    return

# Chỉ đòn khắc chế hệ của unit mới làm giảm break
func reduce_break(damage_model: DamageModel):
    if is_broken or damage_model.element_multiplier <= 1.0:
        return
    damage_model.break_dealt = min(break_gauge, damage_model.break_power)
    break_gauge -= damage_model.break_dealt
    if break_gauge <= 0:
        is_broken = true
        has_lost_turn = false
        damage_model.caused_break = true
    return

# Trả về false nếu unit phải mất lượt này
func begin_turn() -> bool:
    if not is_broken:
        return true
    if not has_lost_turn:
        has_lost_turn = true
        return false
    is_broken = false
    break_gauge = max_break
    BattleEvents.break_recovered.emit(self)
    return true

func set_hp_by_damage(value: int):
    health = max(0, min(max_health, health - value))
    if health <= 0:
        is_fainted = true
    return