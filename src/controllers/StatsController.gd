extends Node
class_name StatsController

# <Database>
var unit_model: UnitModel
var stats_base
var stats_modified
# </Database>

# <Stats>
var health: int
var max_health: int:
	get:
		return get_stat(CharacterBase.StatType.Health)
var attack: int:
	get:
		return get_stat(CharacterBase.StatType.Attack)
var defense: int:
	get:
		return get_stat(CharacterBase.StatType.Defense)
var speed: int:
	get:
		return get_stat(CharacterBase.StatType.Speed)
# </Stats>

# <Init> Khởi tạo
func initialize(_unit_model: UnitModel):
	if _unit_model == null:
		return false
	unit_model = _unit_model
	stats_base = unit_model.base.get_stats()
	stats_modified= unit_model.base.get_stats_default()
	
	health = max_health
	return true
# </Init>

# <Get>
func get_stat(_stat: CharacterBase.StatType):
	var amount_base = (stats_base.get(_stat, 0) * unit_model.level) * 1.0
	var amount_modified = stats_modified.get(_stat, 0) * 1.0
	return max(0, int(amount_base + ((amount_base * amount_modified) / 100.0)))

func set_stat(_stat: CharacterBase.StatType, _amount: int):
	if !stats_base.has(_stat) or !stats_modified.has(_stat):
		return false
	if _stat == CharacterBase.StatType.Speed:
		# Nếu tốc độ bị thay đổi, có thể cần thêm logic để thông báo cho combat system
		unit_model.speed_changed = true  # Đánh dấu là tốc độ đã thay đổ
	stats_base[_stat] = _amount
	return true
# </Get>

# <Set>
func set_health(_value: int):
	health = max(0, _value)
# </Set>

# <Update>
# </Update>
