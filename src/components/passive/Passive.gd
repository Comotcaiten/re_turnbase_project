extends Resource

class_name Passive

# Dùng cho cả passive riêng của nhân vật (UnitBase.passive) và passive của item.
# Kế thừa class này và ghi đè hook cần dùng.
# File .tres được nhiều unit dùng chung nên passive không được lưu trạng thái trên chính nó.
# UnitModel chỉ gọi hook đúng vai trò của unit, nên không cần tự lọc source/target.

# Trước khi trừ máu: có thể đổi sát thương bằng damage_model.set_damage()
func on_before_deal_damage(_unit: UnitModel, _damage_model: DamageModel):
	pass

func on_before_take_damage(_unit: UnitModel, _damage_model: DamageModel):
	pass

# Sau khi trừ máu: damage_dealt, is_lethal, caused_break... đã có giá trị
func on_after_deal_damage(_unit: UnitModel, _damage_model: DamageModel):
	pass

func on_after_take_damage(_unit: UnitModel, _damage_model: DamageModel):
	pass

func on_turn_start(_unit: UnitModel):
	pass
