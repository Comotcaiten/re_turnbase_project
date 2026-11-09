class_name StatusModel

var effect: StatusEffect
var turns_left: int
var stacks: int = 1
var source_attack: int = 0 # ATK của người gây lúc áp hiệu ứng

# WeakRef vì hai unit có thể giữ hiệu ứng của nhau, tham chiếu mạnh sẽ không được giải phóng
var source_ref: WeakRef = null

func _init(_effect: StatusEffect, _source: UnitModel):
	effect = _effect
	turns_left = effect.duration
	set_source(_source)

func refresh(_source: UnitModel):
	turns_left = effect.duration
	stacks = mini(stacks + 1, effect.max_stacks)
	set_source(_source)

func set_source(_source: UnitModel):
	if _source == null:
		source_ref = null
		source_attack = 0
		return
	source_ref = weakref(_source)
	source_attack = _source.attack

func get_source() -> UnitModel:
	return source_ref.get_ref() if source_ref != null else null
