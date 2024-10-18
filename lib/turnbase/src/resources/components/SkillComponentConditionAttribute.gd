extends SkillComponentCondition
class_name SkillComponentConditionAttribute

@export var attribute: AttributeBase.Type
@export var amount_range: Vector2:
  get:
    return Vector2(min(amount_range.x, amount_range.y), max(amount_range.x, amount_range.y))

func is_condition_met(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
  var amount = _target.get_attribute(attribute) * 1.0
  return (amount_range.x <= amount) and (amount <= amount_range.y)