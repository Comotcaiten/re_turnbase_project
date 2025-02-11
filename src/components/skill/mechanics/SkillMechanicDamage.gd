extends SkillMechanic

class_name SkillMechanicDamage

# Properties
@export var power: int = 0 # Tăng sát thương n
@export var type_damage: DamageModel.TypeDamage = DamageModel.TypeDamage.DAMAGE # Kiểu thiệt hại mặc định
@export var true_damage: bool = false # Mặc định không bỏ qua phòng thủ

var damage_model: DamageModel

func apply_mechanic(unit: UnitModel, targets: Array[UnitModel]):
  damage_model = DamageModel.new(power, type_damage, true_damage, Element.Type.PHYSICAL, unit)

  var damage: float = 1

  var attack_power: int = unit.get_stats(Stats.Type.ATTACK)

  match type_damage:
    DamageModel.TypeDamage.DAMAGE:
      damage = (2.0 * (attack_power * 1.0) + 10.0 + power)
    DamageModel.TypeDamage.MULTIPLIER:
      damage = (2.0 * (attack_power * 1.0) + 10.0) * (power * 1.0)
    _: # Do nothing
      damage = 1.0
  
  damage_model.set_damage(int(damage * Element.reactor_element_effect(unit.element, damage_model.element)))

  # print("Skill Mechanic Damage >> Damage >> ", damage)

  for target in targets:
    # target.receive_damage(damage_model)
    var target_damage_model: DamageModel = damage_model.duplicate()
    target_damage_model.set_damage(int(damage * Element.reactor_element_effect(unit.element, target.element)))
    target.take_damage(target_damage_model)
  return