class_name UnitModel

enum Stats {MAXHP, HP, MP, MAXMP, ATTACK, DEFENSE, SPEED}

# Nguồn gốc dữ liệu <Dữ liệu chung>
var base: UnitBase

# Tên của Unit <Dữ liệu chung/cá nhân>
var name: String = "Uname"

# Element/Nguyên tố của Unit <Dữ liệu chung/cá nhân>
var element: Element.Type = Element.Type.PHYSICAL

# Level của Unit <Dữ liệu cá nhân>
var level: int = 1:
	get:
		if level < 0:
			return 1
		return level

# Stats base
var stats_base: StatsBase = StatsBase.new(false)

# Stats modified
var stats_modified: StatsBase = StatsBase.new(true)

# Các giá trị từ stats
var stats: Dictionary = {
	Stats.HP: 1,
	Stats.MP: 1,
	Stats.MAXHP: get_stats(StatsBase.Type.HP),
	Stats.MAXMP: get_stats(StatsBase.Type.MP),
	Stats.ATTACK: get_stats(StatsBase.Type.ATTACK),
	Stats.DEFENSE: get_stats(StatsBase.Type.DEFENSE),
	Stats.SPEED: get_stats(StatsBase.Type.SPEED)
}

# Dữ liệu level scaling của các chỉ số ứng với level
const LEVEL_SCALING = {
	StatsBase.Type.HP: 10.0,
	StatsBase.Type.MP: 5.0,
	StatsBase.Type.ATTACK: 2.5,
	StatsBase.Type.DEFENSE: 3.0,
	StatsBase.Type.SPEED: 1.5
}

# Khởi tạo
func _init(_base: UnitBase, _level: int = 1):
	base = _base
	level = _level

	name = _base.name
	element = _base.element
	stats_base = _base.stats_base

	set_stats(stats[Stats.HP], stats.get(Stats.MAXHP, 1))
	set_stats(stats[Stats.MP], stats.get(Stats.MAXMP, 1))
	pass

# Get
func get_stats(stat: StatsBase.Type) -> int:
	var base_value: float = max(0.0, stats_base.get_stats(stat))  # Chỉ số gốc
	var modified_value: float = stats_modified.get_stats(stat)  # % tăng/giảm (có thể âm)
	var scaling: float = LEVEL_SCALING.get(stat, 5.0)  # Giá trị mặc định x5 nếu không tìm thấy

	# Tính toán: base * (1 + %mod/100) + level * scaling
	var final_value = base_value * (1.0 + modified_value / 100.0) + (level * scaling)

	# return max(1, int(final_value))  # Đảm bảo chỉ số không âm
	return clamp(int(final_value), 1, 9999)  # Giới hạn từ 1 đến 9999

# Set
func set_stats(stat: Stats, value: int) -> bool:
	if stat in stats:
		stats[stat] = max(0, value)  # Đảm bảo không âm
		return true
	return false

# Event trong game
func heal(amount: int) -> void:
	# stats[Stats.HP] = min(stats[Stats.MAXHP], stats[Stats.HP] + amount)
	set_stats(stats[Stats.HP], min(stats[Stats.MAXHP], stats[Stats.HP] + amount))
	return

func restore_mp(amount: int) -> void:
	# stats[Stats.MP] = min(stats[Stats.MAXMP], stats[Stats.MP] + amount)
	set_stats(stats[Stats.MP], min(stats[Stats.MAXMP], stats[Stats.MP] + amount))
	return

# Chức năng khác
# Tạo một bản sao không tham chiếu
func duplicate() -> UnitModel:
	var copy = UnitModel.new(base, level)
	copy.name_override = self.name_override
	copy.stats = self.stats.duplicate(true)  # Sao chép Dictionary để tránh tham chiếu chung
	return copy