extends Resource

class_name SkillComponent

@export_group("Components")
@export var conditions: Array[SkillCondition]
@export var mechanics: Array[SkillMechanic]

func excute(targets: Array[UnitModel] = [], source: UnitModel = null, skill: SkillModel = null, battle_system: BattleSystemController = null) -> bool:
  # Check if the targets are legal
  if not check_targets(targets, source, skill, battle_system):
    return false
  # Check if the conditions are met
  if not check_conditions(targets, source, skill, battle_system):
    return false
  # Apply the mechanics
  return apply_mechanics(targets, source, skill, battle_system)

# First: Check targets is legal
func check_targets(targets: Array[UnitModel] = [], source: UnitModel = null, skill: SkillModel = null, battle_system: BattleSystemController = null) -> bool:
  if targets.size() == 0 or source == null or skill == null or battle_system == null:
    return false
  match skill.target_type:
    SkillBase.TargetType.SELF:
      if targets.size() != 1 or targets[0] != source:
        return false
    SkillBase.TargetType.ENEMY:
      for target in targets:
        if target.team == source.team:
          return false
    SkillBase.TargetType.ALLY:
      for target in targets:
        if target.team != source.team:
          return false
    SkillBase.TargetType.ANY:
      pass
  return true

# Second: Check conditions
func check_conditions(targets: Array[UnitModel] = [], source: UnitModel = null, skill: SkillModel = null, battle_system: BattleSystemController = null) -> bool:
  if conditions.size() == 0:
    return true
  for condition in conditions:
    if not condition.check(targets, source, skill, battle_system):
      return false
  return true

# Third: Apply mechanics
func apply_mechanics(targets: Array[UnitModel] = [], source: UnitModel = null, skill: SkillModel = null, battle_system: BattleSystemController = null) -> bool:
  if mechanics.size() == 0:
    return true
  for mechanic in mechanics:
    if not mechanic.apply_mechanic(targets, source, skill, battle_system):
      return false
  return true