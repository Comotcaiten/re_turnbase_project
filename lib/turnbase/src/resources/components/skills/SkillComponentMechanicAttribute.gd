extends SkillComponentMechanic
class_name SkillComponentMechanicAttribute

enum TypeEffect {Increase, Decrease}

@export var type_effect: TypeEffect
@export var attribute: AttributeBase.Type
@export var amount: int:
  get:
    return max(0, abs(amount))

func apply(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
  unit_service.take_attribute_effect(_target, calculator_effect(_target, _source, _skill))
  return true

func calculator_effect(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> AttributeEffect:
  var amount_use = 0
  match type_effect:
    TypeEffect.Increase:
      amount_use = amount
    TypeEffect.Decrease:
      amount_use = amount * (-1)
  return AttributeEffect.new(attribute, amount_use)