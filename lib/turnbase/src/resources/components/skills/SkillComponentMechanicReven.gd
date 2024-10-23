extends SkillComponentMechanic
class_name SkillComponentMechanicReven

func apply(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
    _target.hp = _target.max_hp
    return _target.hp <= 0