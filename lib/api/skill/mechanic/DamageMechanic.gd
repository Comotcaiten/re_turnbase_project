extends SkillMechanic
class_name DamageMechanic

@export var power: int

func Apply(_source: Character, _target: Character) -> bool:
    _target.hp -= power
    if _target.hp <= 0:
        return true
    return false

func CalculateDamageTaken(_source: Character, _target: Character) -> int:
    if _source == null:
        return 0
    var _critical = 1.0
    return 1
    # if _source == null:
	# 	return 0
	# var critical = 1.0
	# var typeEff = 1.0

	# if _skill != null:
	# 	typeEff = ElementEffectiveness.GetEffectiveness(_attacker.base.element, base.element)
	
	# var attacker_damage = _attacker.attack
	# if _attacker.mainHand != null:
	# 	attacker_damage += _attacker.mainHand.damage
	
	# var a = (2.0 * attacker_damage + 10.0) * typeEff * critical * randf_range(0.85, 1.0)
	# var damage = ((a / (defense * 1.0))) + 2.0
	# print("[>] ", nameCharacter, " took ", damage, " DMG")
	# print("[>] ", nameCharacter, " has ", hp, "/", max_hp, " HP")

	# return int(damage)