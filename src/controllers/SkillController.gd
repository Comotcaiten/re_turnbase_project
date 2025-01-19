class_name SkillController

# Điều phối các hành động của SkillService.
# => Chẳng hạn như khi người chơi hoặc AI sử dụng một kỹ năng.

var skill_service: SkillService

# Khởi tạo controller với service
func _init():
    skill_service = SkillService.new()

# # Sử dụng kỹ năng
# func use_skill(unit: UnitModel, skill_name: String, target: UnitModel) -> void:
#     var skill = skill_service.get_skill_by_name(skill_name)
#     if skill:
#         skill_service.use_skill(unit, skill, target)
#     else:
#         print("Không tìm thấy kỹ năng với tên: " + skill_name)