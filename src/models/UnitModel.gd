class_name UnitModel

# HP, MP, break hoặc item thay đổi
signal changed

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

# Item
const MAX_ITEM_SLOTS := 8
const MAX_ITEM_COST := 12

var items: Array[ItemBase] = []

# Hiệu ứng trạng thái
var statuses: Array[StatusModel] = []

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

    BattleEvents.damage_before.connect(_on_damage_before)
    BattleEvents.damage_after.connect(_on_damage_after)
    BattleEvents.turn_started.connect(_on_turn_started)

    for skill in _base.skills:
        if skill is SkillBase:
            skills.append(SkillModel.new(skill))
    pass

# Get
func get_stats(_stat: Stats.Type) -> int:
    var amount_base = stats_base.get_stats(_stat) * 1.0
    var amount_modified = stats_modified.get_stats(_stat) * 1.0
    var amount: int = int(((amount_base + (amount_modified + amount_base)) / 100.0) * level) + get_item_bonus(_stat)
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
    if damage_model.is_miss:
        BattleEvents.damage_after.emit(damage_model)
        return
    BattleEvents.damage_before.emit(damage_model)

    damage_model.hp_before = health
    set_hp_by_damage(damage_model.get_damage())
    damage_model.hp_after = health
    damage_model.damage_dealt = damage_model.hp_before - health
    damage_model.is_lethal = is_fainted
    reduce_break(damage_model)
    changed.emit()

    BattleEvents.damage_after.emit(damage_model)
    return

# Trả về lượng máu thực sự được hồi
func heal(amount: int) -> int:
    if is_fainted or amount <= 0:
        return 0
    var healed: int = mini(amount, max_health - health)
    health += healed
    changed.emit()
    return healed

func get_crit_chance() -> int:
    var total: int = base.crit_chance
    for status in statuses:
        total += status.effect.get_crit_bonus(status)
    return total

func get_accuracy() -> int:
    var total: int = base.accuracy
    for status in statuses:
        total += status.effect.get_accuracy_bonus(status)
    return total

# Cùng loại hiệu ứng thì làm mới số lượt và cộng stack thay vì thêm bản mới
func apply_status(effect: StatusEffect, source: UnitModel = null):
    if effect == null or is_fainted:
        return
    var applied: StatusModel = null
    for status in statuses:
        if status.effect.get_script() == effect.get_script():
            status.refresh(source)
            applied = status
    if applied == null:
        applied = StatusModel.new(effect, source)
        statuses.append(applied)
    changed.emit()
    BattleEvents.status_applied.emit(self, applied)
    return

func remove_status(status: StatusModel):
    statuses.erase(status)
    changed.emit()
    BattleEvents.status_removed.emit(self, status)
    return

func take_status_damage(amount: int, status: StatusModel):
    var damage_model := DamageModel.new(0, DamageModel.TypeDamage.DAMAGE, true, Element.Type.PHYSICAL, status.get_source())
    damage_model.from_passive = true
    damage_model.status = status
    damage_model.set_damage(amount)
    take_damage(damage_model)
    return

# Trả về false nếu có hiệu ứng khiến unit mất lượt này
func tick_statuses() -> bool:
    var can_act: bool = true
    for status in statuses.duplicate():
        if status.turns_left <= 0:
            remove_status(status)
            continue
        status.effect.on_turn_start(self, status)
        if is_fainted:
            return false
        if status.effect.prevents_action(status):
            can_act = false
        status.turns_left -= 1
    changed.emit()
    return can_act

func get_passives() -> Array[Passive]:
    var passives: Array[Passive] = []
    if base.passive != null:
        passives.append(base.passive)
    for item in items:
        passives.append_array(item.passives)
    return passives

func _on_damage_before(damage_model: DamageModel):
    if damage_model.from_passive:
        return
    for passive in get_passives():
        if damage_model.source == self:
            passive.on_before_deal_damage(self, damage_model)
        if damage_model.target == self:
            passive.on_before_take_damage(self, damage_model)

func _on_damage_after(damage_model: DamageModel):
    if damage_model.from_passive or damage_model.is_miss:
        return
    for passive in get_passives():
        if damage_model.source == self:
            passive.on_after_deal_damage(self, damage_model)
        if damage_model.target == self:
            passive.on_after_take_damage(self, damage_model)

func _on_turn_started(unit: UnitModel):
    if unit != self:
        return
    for passive in get_passives():
        passive.on_turn_start(self)

func get_item_bonus(_stat: Stats.Type) -> int:
    var total: int = 0
    for item in items:
        total += item.get_bonus(_stat)
    return total

func get_item_cost() -> int:
    var total: int = 0
    for item in items:
        total += item.cost
    return total

func can_equip_item(item: ItemBase) -> bool:
    return item != null and items.size() < MAX_ITEM_SLOTS and get_item_cost() + item.cost <= MAX_ITEM_COST

func equip_item(item: ItemBase) -> bool:
    if not can_equip_item(item):
        print("UnitModel >> Equip failed >> ", name, " >> Slots: ", items.size(), "/", MAX_ITEM_SLOTS, " >> Cost: ", get_item_cost(), "/", MAX_ITEM_COST)
        return false
    var old_max_hp: int = max_health
    var old_max_mp: int = max_mp
    items.append(item)
    refresh_after_item_change(old_max_hp, old_max_mp)
    return true

func unequip_item(item: ItemBase) -> bool:
    if item not in items:
        return false
    var old_max_hp: int = max_health
    var old_max_mp: int = max_mp
    items.erase(item)
    refresh_after_item_change(old_max_hp, old_max_mp)
    return true

# Máu tối đa tăng thì máu hiện tại tăng theo, giảm thì chỉ cắt phần vượt quá
func refresh_after_item_change(old_max_hp: int, old_max_mp: int):
    if not is_fainted:
        health += maxi(0, max_health - old_max_hp)
    mp += maxi(0, max_mp - old_max_mp)
    health = mini(health, max_health)
    mp = mini(mp, max_mp)
    changed.emit()
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
    var can_act: bool = advance_break()
    if not tick_statuses():
        can_act = false
    return can_act and not is_fainted

func advance_break() -> bool:
    if not is_broken:
        return true
    if not has_lost_turn:
        has_lost_turn = true
        return false
    is_broken = false
    break_gauge = max_break
    changed.emit()
    BattleEvents.break_recovered.emit(self)
    return true

func set_hp_by_damage(value: int):
    health = max(0, min(max_health, health - value))
    if health <= 0:
        is_fainted = true
    return