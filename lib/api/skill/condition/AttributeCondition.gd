extends SkillCondition
class_name AttributeCondition

@export var attribute: CharacterBase.Attribute
@export_group("Amount range (min, max)")
@export var amount_range: Vector2 = Vector2(0, 0):
  get:
    if amount_range.x > amount_range.y:
      var temp = amount_range.x
      amount_range.x = amount_range.y
      amount_range.y = temp
    return amount_range

# Kiểm tra xem điều kiện đã đạt hay không
func IsConditionMet(target: Character) -> bool:
  # Lấy giá trị của chỉ số từ đối tượng nhân vật
  # => target.GetAttribute(attribute)
  # Kiểm tra xem giá trị hiện tại có nằm trong khoảng cho phép không
  var amount = target.GetAttribute(attribute)
  print("[>] Amount: ", amount)
  print("[>] Amount Range: ", amount_range)
  print("[>] Is Conidition Met: ", amount_range.x <= (amount * 1.0) or (amount * 1.0) <= amount_range.y)
  if amount_range.x <= (amount * 1.0) or (amount * 1.0) <= amount_range.y:
    return true
  return false