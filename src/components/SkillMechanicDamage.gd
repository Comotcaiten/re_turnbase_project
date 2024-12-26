extends SkillMechanic

class_name SkillMechanicDamage

# Properties
@export var power: int = 0 # Tăng sát thương n
@export var type_attack: DamageModel.TypeAttack = DamageModel.TypeAttack.Physical # Kiểu tấn công mặc định
@export var type_damage: DamageModel.TypeDamage = DamageModel.TypeDamage.Damage # Kiểu thiệt hại mặc định
@export var true_damage: bool = false # Mặc định không bỏ qua phòng thủ


func apply_mechanic(targets: Array[UnitModel] = [], source: UnitModel = null, skill: SkillModel = null, battle_system: BattleSystemController = null) -> bool:
  if targets.size() == 0 or source == null or skill == null or battle_system == null:
    return false
  for target in targets:
    var damage_model = DamageModel.new(power, type_attack, type_damage, true_damage, skill.element)
    damage_model.set_calculate_damage(target, source)
    target.take_damage(damage_model, source)
  return true