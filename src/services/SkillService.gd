class_name SkillService

# Quản lý tất cả các chức năng liên quan đến kỹ năng (SkillModel), 
# => Chẳng hạn như thêm, sửa đổi, hoặc tìm kiếm kỹ năng.

# Thêm kỹ năng vào đơn vị
func add_skill_to_unit(unit: UnitModel, skill: SkillModel) -> void:
    unit.skills.append(skill)

# Xóa kỹ năng khỏi đơn vị
func remove_skill_from_unit(unit: UnitModel, skill: SkillModel) -> void:
    unit.skills.erase(skill)

# Tìm kiếm kỹ năng theo tên
func get_skill_by_name(unit: UnitModel, name: String = "") -> SkillModel:
    for skill in unit.skills:
        if skill.name == name:
            return skill
    return null

# Sử dụng kỹ năng của một đơn vị
func use_skill(unit: UnitModel, skill: SkillModel, target: UnitModel) -> void:
    if skill in unit.skills:
        skill.activate(unit, target)  # Gọi hàm kích hoạt kỹ năng từ SkillModel
