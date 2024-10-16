extends SkillMechanic
class_name BuffMechanic

@export var attribute: CharacterBase.Attribute
@export var amount: int:
  get:
    return max(0, amount)

# Ghi đè phương thức Apply để thực hiện cơ chế buff
func Apply(_source: Character, _target: Character, _skill: Skill):
  print("[]")
  _target.SetAttributeModified(attribute, amount)
  print("[>] Buff applied to ", attribute, " with amount ", amount)
