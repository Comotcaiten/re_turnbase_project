extends Resource
class_name SkillComponent

enum ConditionCheckMode {One, Amount, All} # Lấy bao nhiêu điều kiện (One chỉ cần một condition true, Amount: set up số lượng true, All - tất cả phải true)

@export var name: String

@export_group("Condition Mode")
@export var condition_mode: ConditionCheckMode
@export var amount_for_mode_amount: int:
  get:
    return max(1, amount_for_mode_amount)

@export_group("Components")
@export var conditions: Array[SkillCondition]
@export var mechanics: Array[SkillMechanic]

func run(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  var is_condition_met: bool = run_component(_target, _source, _skill, _battle_system)
  if is_condition_met:
    for mechanic in mechanics:
      mechanic.apply_mechanic(_target, _source, _skill, _battle_system)
  return is_condition_met

func run_component(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  if _target.is_empty() or _source == null or _skill == null or _battle_system == null:
    return false

	# Kiểm tra danh sách các điều kiện và các mechanics
  if conditions.is_empty() or mechanics.is_empty():
    return false
  
  var is_condition_met: bool = false
  # Kiểm tra điều kiện
  match condition_mode:
    ConditionCheckMode.One:
      is_condition_met = run_check_one(_target, _source, _skill, _battle_system)
    ConditionCheckMode.Amount:
      is_condition_met = run_check_amount(_target, _source, _skill, _battle_system)
    ConditionCheckMode.All:
      is_condition_met = run_check_all(_target, _source, _skill, _battle_system)
  return is_condition_met

func run_check_one(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  if conditions == []:
    return true

  for condition in conditions:
    if condition == null:
      continue
    if condition.is_condition_met(_target, _source, _skill, _battle_system):
      return true
  return false

func run_check_amount(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  if conditions == []:
    return false
  
  var counter: int = 0
  for condition in conditions:
    if condition == null:
      continue
    if condition.is_condition_met(_target, _source, _skill, _battle_system):
      counter += 1
    if counter == amount_for_mode_amount:
      return true
  return false

func run_check_all(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  if conditions == []:
    return true

  for condition in conditions:
    if condition == null:
      continue
    if !condition.is_condition_met(_target, _source, _skill, _battle_system):
      return false
  return true