extends Resource
class_name SkillComponentMechanic

var unit_service: UnitService = UnitService.new()

func apply(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
    return false