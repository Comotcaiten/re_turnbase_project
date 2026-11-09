extends SkillMechanic

class_name SkillMechanicDamage

# Properties
@export var power: int = 0 # Tăng sát thương n
@export var type_damage: DamageModel.TypeDamage = DamageModel.TypeDamage.DAMAGE # Kiểu thiệt hại mặc định
@export var true_damage: bool = false # Mặc định không bỏ qua phòng thủ
@export var break_power: int = 50 # Lượng break giảm khi khắc hệ mục tiêu

func apply_mechanic(unit: UnitModel, targets: Array[UnitModel], skill: SkillModel):
  var damage: float = 1

  var attack_power: int = unit.get_stats(Stats.Type.ATTACK)

  match type_damage:
    DamageModel.TypeDamage.DAMAGE:
      damage = (2.0 * (attack_power * 1.0) + 10.0 + power)
    DamageModel.TypeDamage.MULTIPLIER:
      damage = (2.0 * (attack_power * 1.0) + 10.0) * (power * 1.0)
    _: # Do nothing
      damage = 1.0
  
  print("Skill Mechanic Damage >> Damage >> ", damage)

  for target in targets:
    # Mỗi mục tiêu một DamageModel riêng để kết quả không ghi đè nhau
    var damage_model := DamageModel.new(power, type_damage, true_damage, skill.element, unit, skill)
    damage_model.set_damage(int(damage))
    damage_model.break_power = break_power
    target.take_damage(damage_model)
  return