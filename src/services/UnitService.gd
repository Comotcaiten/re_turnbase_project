class_name UnitService

# Quản lý các chức năng liên quan đến đơn vị (UnitModel)
# => Ví dụ như tạo đơn vị, cập nhật thông tin, kiểm tra trạng thái, và thực hiện các hành động của đơn vị.

# Tạo một đơn vị mới từ UnitBase
func create_unit(base: UnitBase, level: int) -> UnitModel:
    if base == null or level <= 0:
        return null
    var unit = UnitModel.new(base, level)
    return unit

# Cập nhật trạng thái của một đơn vị (ví dụ: cập nhật máu, MP, trạng thái ngất)
func update_unit_status(unit: UnitModel, status: String) -> void:
    match status:
        "faint":
            unit.is_fainted = true
        "revive":
            unit.is_fainted = false
        # Thêm các trạng thái khác nếu cần
        _:
            print("Trạng thái không hợp lệ")

# Kiểm tra xem đơn vị có bị ngất không
func is_unit_fainted(unit: UnitModel) -> bool:
    return unit.is_fainted