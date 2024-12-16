extends Resource
class_name SkillCondition


func is_condition_met(_target: Array[UnitModel], _source: UnitModel, _skill: SkillModel, _battle_system: BattleSystemController) -> bool:
  return true