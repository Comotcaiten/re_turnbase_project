class_name UnitGroupModel

var db: Array[UnitModel]  # Danh sách các đơn vị trong nhóm

# Thêm một đơn vị vào nhóm
func add_unit(unit: UnitModel = null) -> bool:
    if unit == null:
        return false
    if unit in db:
        print("Unit da ton tai trong group!")
        return false
    db.append(unit)
    return true

# Xóa một đơn vị khỏi nhóm
func remove_unit(unit: UnitModel = null) -> bool:
    if unit == null:
        return false
    if !unit in db:
        print("Khong the xoa vi uni chua ton tai!")
        return false
    db.erase(unit)
    return true

# Lấy đơn vị theo ID
func get_unit_by_id(id: String) -> UnitModel:
    for unit in db:
        if unit.id == id:
            return unit
    return null

# Hàm so sánh để sắp xếp theo tốc độ
func _compare_speed(a: UnitModel, b: UnitModel) -> int:
    return a.speed - b.speed  # Hoặc bất kỳ yếu tố nào bạn muốn dùng để quyết định lượt
