extends SkillMechanic
class_name SkillMechanicDamage

enum TypeDamage {Damage, Multiplier, PercentLeft, PercentMising}

@export var damage_type: TypeDamage
@export var power: int
@export var true_damage: bool

func apply_mechanic(_target: UnitModel, _source: UnitModel, _skill: SkillModel):
    # print("[SkillMechanicDamage]")
    
    var detail: DamageDetailModel = calculatro_damage(_target, _source, _skill)
    _skill.damage_detail = detail
    _target.take_damage(_source, _skill)

func calculatro_damage(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> DamageDetailModel:
    if (_target == null) or (_source == null) or (_skill == null):
        return DamageDetailModel.new(_source, 0, true_damage)

    var critical = 1.0
    var attacker_damage = (_source.stats_controller.attack * 1.0)
    var damage = 0

    match damage_type:
        TypeDamage.Damage:
            # Sát thương cơ bản
            damage = (2.0 * attacker_damage + 10.0 + power) * critical * randf_range(0.85, 1.0)
        TypeDamage.Multiplier:
            # Nhân với sức mạnh (power)
            damage = (2.0 * attacker_damage * power + 10.0) * critical * randf_range(0.85, 1.0)
        TypeDamage.PercentLeft:
            # Gây sát thương dựa trên % máu còn lại của mục tiêu
            damage = power * ((_target.stats_controller.health * 1.0) / 100.0)
        TypeDamage.PercentMising:
            # Gây sát thương dựa trên % máu đã mất của mục tiêu
            var missing_hp = _target.max_hp - _target.hp
            damage = missing_hp * (power / 100.0)

    return DamageDetailModel.new(_source, damage, true_damage)