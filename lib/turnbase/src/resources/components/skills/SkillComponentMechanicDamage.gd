extends SkillComponentMechanic
class_name SkillComponentMechanicDamage

enum TypeDamage {Damage, Multiplier, PercentLeft, PercentMising}

@export var damage_type: TypeDamage
@export var power: int
@export var true_damage: bool

func apply(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
  unit_service.take_damage(_target, calculator_damage(_source, _target, _skill))
  return _target.hp <= 0

func calculator_damage(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> DamageDetailModel:
  var damage_detail = DamageDetailModel.new(0, ElementBase.Type.None, false, 0)
  if (_target == null) or (_source == null) or (_skill == null):
    return damage_detail
  
  var critical = 1.0
  var type_eff = 1.0

  var element: ElementBase.Type

  if _skill != null:
    type_eff = ElementService.get_effectiveness(_skill.element, _target.element)
    element = _skill.element
  else:
    type_eff = ElementService.get_effectiveness(_source.element, _target.element)
    element = _source.element
  
  var attacker_damage = _source.attack

  var damage = 0
  match damage_type:
    TypeDamage.Damage:
			# Sát thương cơ bản
      damage = (2.0 * attacker_damage + 10.0) * type_eff * critical * randf_range(0.85, 1.0)
      # damage = ((a / (target_defense * 1.0))) + 2.0
		
    TypeDamage.Multiplier:
      # Nhân với sức mạnh (power)
      damage = (2.0 * attacker_damage + 10.0) * type_eff * critical * randf_range(0.85, 1.0) * power
      # damage = ((a / (target_defense * 1.0))) * power + 2.0
		
    TypeDamage.PercentLeft:
			# Gây sát thương dựa trên % máu còn lại của mục tiêu
      damage = power * (_target.hp / 100.0)
		
    TypeDamage.PercentMising:
			# Gây sát thương dựa trên % máu đã mất của mục tiêu
      var missing_hp = _target.max_hp - _target.hp
      damage = missing_hp * (power / 100.0)

  return DamageDetailModel.new(max(0, int(damage)), element, true_damage, 0)