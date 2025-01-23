extends Node

class_name SkillController

var current_index: int
var current_skill: SkillModel
var battle_system: BattleSystem

func initialized(_battle_system: BattleSystem):
    battle_system = _battle_system
    pass

func set_index_skill(index: int, unit: UnitModel) -> bool:
  if index < 0 or current_index < 0:
    current_index = 0
    return false
  if current_index >= unit.skills.size():
    current_index = 0
    return false
  if index >= unit.skills.size():
    return false
  current_index = index
  return true

func get_skill(unit: UnitModel) -> SkillModel:
  if current_index >= unit.skills.size():
    return
  current_skill = unit.get_skill(current_index)
  return current_skill

func refesh():
  current_index = 0
  current_skill = null