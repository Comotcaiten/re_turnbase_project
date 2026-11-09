class_name DamageModel

enum TypeDamage {DAMAGE, MULTIPLIER, PERCENTLEFT, PERCENTMISSING}
# enum TypeAttack {Physical, Magic}

# Properties
var power: int = 0 # Tăng sát thương n
var type_damage: TypeDamage = TypeDamage.DAMAGE # Kiểu thiệt hại mặc định
var true_damage: bool = false # Mặc định không bỏ qua phòng thủ

var element: Element.Type

var damage: int = 0

var source: UnitModel = null
var target: UnitModel = null
var skill: SkillModel = null
var from_passive: bool = false # Damage từ passive/hiệu ứng: không kích hoạt passive khác, không trượt, không crit
var status: StatusModel = null # Hiệu ứng gây ra damage này, nếu có

# Kết quả, có giá trị sau khi trừ máu
var damage_dealt: int = 0 # Lượng máu thực sự bị mất
var hp_before: int = 0
var hp_after: int = 0
var is_lethal: bool = false
var defense_applied: int = 0
var element_multiplier: float = 1.0

# Break
var break_power: int = 0 # Lượng break giảm nếu đòn này khắc hệ mục tiêu
var break_dealt: int = 0
var caused_break: bool = false # Đòn này làm mục tiêu bị break
var break_multiplier: float = 1.0 # Tăng sát thương vì mục tiêu đang bị break

# Chính xác và crit
var is_miss: bool = false
var is_crit: bool = false
var crit_multiplier: float = 1.0

func _init(_power: int = 0, _type_damage: TypeDamage = TypeDamage.DAMAGE, _true_damage: bool = false, _element: Element.Type = Element.Type.PHYSICAL, _source: UnitModel = null, _skill: SkillModel = null):
  power = _power
  type_damage = _type_damage
  true_damage = _true_damage
  element = _element
  source = _source
  skill = _skill
  return

# Áp defense rồi đến khắc hệ của mục tiêu vào sát thương
func resolve_against(_target: UnitModel):
  target = _target
  if source != null and not from_passive:
    is_miss = randi_range(1, 100) > source.get_accuracy()
    if is_miss:
      return
    is_crit = randi_range(1, 100) <= source.get_crit_chance()
    if is_crit:
      crit_multiplier = source.base.crit_damage / 100.0
  var amount: float = damage
  if not true_damage:
    defense_applied = target.defense
    amount -= defense_applied
  element_multiplier = Element.get_multiplier(element, target.element)
  if target.is_broken:
    break_multiplier = UnitModel.BREAK_DAMAGE_MULTIPLIER
  set_damage(int(amount * element_multiplier * break_multiplier * crit_multiplier))
  return

func _to_string() -> String:
  return "%s -> %s | Skill: %s | Element: %s x%.1f | Defense: %d | Damage: %d | HP: %d -> %d | Break: -%d x%.1f%s%s%s%s" % [
    source.name if source else "None",
    target.name if target else "None",
    skill.name if skill else (status.effect.name if status else "None"),
    Element.Type.keys()[element],
    element_multiplier,
    defense_applied,
    damage_dealt,
    hp_before,
    hp_after,
    break_dealt,
    break_multiplier,
    " | BROKE" if caused_break else "",
    " | LETHAL" if is_lethal else "",
    " | CRIT" if is_crit else "",
    " | MISS" if is_miss else ""
  ]

func set_damage(_damage: int):
  damage = max(1, _damage)
  return

func get_damage() -> int:
  return max(1, damage)