extends SkillCondition
class_name SkillConditionStats

@export var stat: CharacterBase.StatType
@export var range_amount: Vector2:
    get:
        return Vector2(min(range_amount.x, range_amount.y), max(range_amount.x, range_amount.y))

func is_condition_met(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
    var amount_stat = _target.stats_controller.get_stat(stat)
    return range_amount.x <= amount_stat and amount_stat <= range_amount.y