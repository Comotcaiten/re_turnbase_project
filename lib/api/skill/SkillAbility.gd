extends Resource
class_name SkillAbility

@export var target: SkillBase.Target

@export var condition: SkillCondition

@export var mechanic: SkillMechanic

func CanApply(_source: Character, _target: Character) -> bool:
    var _get_target: Character
    match target:
        SkillBase.Target.Foe:
            print("Foe")
            _get_target = _target
        SkillBase.Target.Self:
            print("Self")
            _get_target = _source

    if _CanRun(_get_target):
        print("[>] Can run skill mechanic")
        _RunMechanic(_get_target)
    else:
        print("[!] Can not run skill mechanic")
    return true

func _CanRun(_target: Character):
    print("[>] Check Skill Condition")
    if condition is AttributeCondition:
        print("[>] AttributeCondition")
        var _condition_attr: AttributeCondition = condition
        return _condition_attr.IsConditionMet(_target)
    return 0

func _RunMechanic(_target: Character):
    var _mechanic
    if mechanic is DamageMechanic:
        var _mechanic_dmg: DamageMechanic = mechanic
        _mechanic = _mechanic_dmg
    _mechanic.Apply(_target)
    return 0