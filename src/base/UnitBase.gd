extends Resource

class_name UnitBase

@export var name: String = "Unnamed Unit"
@export var id: String
@export var element: Element.Type
@export var stats: Stats
@export var skills: Array[SkillBase] = []

# Hàm khởi tạo cho phép dễ dàng tạo mới một Unit
# func _init(_name: String = "Unnamed Unit", _stats: Stats = null, _element: Element.Type = Element.Type, _skills: Array[SkillBase] = []):
# 	name = _name
# 	stats = _stats if _stats else Stats.new()
# 	element = _element
# 	skills = _skills

# Lấy thông tin stats của unit theo loại
func get_stat(_type: Stats.Type) -> int:
	if stats:
		return stats.get_stats(_type)
	return 0

# Thêm kỹ năng mới cho unit
func add_skill(skill: SkillBase) -> void:
	if skill not in skills:
		skills.append(skill)

# Xóa kỹ năng khỏi unit
func remove_skill(skill: SkillBase) -> void:
	if skill in skills:
		skills.erase(skill)

# Kiểm tra xem unit có kỹ năng cụ thể hay không
func has_skill(skill: SkillBase) -> bool:
	return skill in skills

# Trả về thông tin unit dưới dạng chuỗi để debug/logging
func information() -> String:
	return "%s | Element: %s | Stats: %s | Skills: %s" % [
		name, str(element), stats.to_string(), skills_to_string()
	]

# Chuyển mảng kỹ năng thành chuỗi
func skills_to_string() -> String:
	var skill_names = skills.map(func(s): return s.name)
	return ", ".join(skill_names)
