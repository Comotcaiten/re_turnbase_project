extends SkillMechanic
class_name BuffMechanic

@export var attribute: CharacterBase.Attribute
@export var amount: int:
  get:
    return abs(amount)

# Ghi đè phương thức Apply để thực hiện cơ chế buff
func Apply(character: Character):
    character.SetAttributeModified(attribute, amount)
    print("Buff applied to ", attribute, " with amount ", amount)
