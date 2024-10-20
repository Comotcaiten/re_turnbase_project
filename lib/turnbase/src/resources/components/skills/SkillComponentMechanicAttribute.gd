extends SkillComponentMechanic
class_name SkillComponentMechanicAttribute

enum TypeEffect {Increase, Decrease}

@export var type_effect: TypeEffect
@export var attribute: AttributeBase.Type
@export var amount: int:
  get:
    return max(0, abs(amount))