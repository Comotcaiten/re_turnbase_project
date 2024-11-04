# SkillComponent định nghĩa
extends Resource
class_name SkillComponent

enum ConditionCheckMode {One, Amount, All} # Lấy bao nhiêu điều kiện (One chỉ cần một condition true, Amount: set up số lượng true, All - tất cả phải true)


@export var name: String

@export_group("Condition Mode")
@export var condition_mode: ConditionCheckMode
@export var amount_for_mode_amount: int:
	get:
		return max(1, amount_for_mode_amount)

@export_group("Components")
@export var conditions: Array[SkillCondition]
@export var mechanics: Array[SkillMechanic]

func active(_target: UnitModel, _source: UnitModel, _skill: SkillModel) -> bool:
	print("[SkillComponent] Active ", name)
	if _target == null or _source == null or _skill == null:
		return false

	var get_target = _target
	match _skill.base.target_type:
		SkillBase.TargetType.Self:
			get_target = _source
		SkillBase.TargetType.Enemy:
			get_target = _target
		_:
			get_target = _target
	
	var is_condition_met: bool = false

	# Kiểm tra danh sách các điều kiện và các mechanics
	if conditions.is_empty() or mechanics.is_empty():
		return is_condition_met

	# Kiểm tra điều kiện
	match condition_mode:
		ConditionCheckMode.One:
			for condition in conditions:
				if condition == null:
					continue
				if condition.is_condition_met(get_target, _source, _skill):
					is_condition_met = true
					break
		ConditionCheckMode.Amount:
			var counter: int = 0
			for condition in conditions:
				if condition == null:
					continue
				if condition.is_condition_met(get_target, _source, _skill):
					counter += 1
			if counter == _skill.base.amount_for_mode_amount:
				is_condition_met = true
		ConditionCheckMode.All:
			is_condition_met = true
			for condition in conditions:
				if condition == null:
					continue
				if !condition.is_condition_met(get_target, _source, _skill):
					is_condition_met = false
					break

	# Áp dụng cơ chế nếu điều kiện thỏa mãn
	if is_condition_met:
		for mechanic in mechanics:
			if mechanic == null:
				continue
			mechanic.apply_mechanic(get_target, _source, _skill)
	
	return is_condition_met
