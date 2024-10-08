extends Resource
class_name SkillBase

enum Target { Foe, Self }
enum CostType { MP, HP, OTHER }
# enum CategoryType { ATTACK, DEFENSE, SUMMON, HEAL, OTHER }

@export var icon: Texture2D
@export var name: String
@export var element: CharacterBase.Element
@export var target: Target

@export_group("Cost")
@export var cost_type: CostType = CostType.MP
@export var cost_amount: int

@export_group("Core")
@export var core: SkillCore

func CanUse(character: Character) -> bool:
    match cost_type:
        CostType.MP:
            return character.mp >= cost_amount
        CostType.HP:
            return character.hp >= cost_amount
        CostType.OTHER:
            return false
    return false
