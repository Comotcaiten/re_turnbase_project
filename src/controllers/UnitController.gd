class_name UnitController

# Điều phối các hành động của UnitService.
# => Như tạo đơn vị, cập nhật trạng thái, và kiểm tra trạng thái ngất của đơn vị.

var unit_service: UnitService

# Khởi tạo controller với service
func _init():
    unit_service = UnitService.new()

# Tạo một đơn vị mới
func create_unit(base: UnitBase, level: int) -> UnitModel:
    return unit_service.create_unit(base, level)

# Cập nhật trạng thái của đơn vị
func update_unit_status(unit: UnitModel, status: String) -> void:
    unit_service.update_unit_status(unit, status)

# Kiểm tra trạng thái ngất
func check_unit_fainted(unit: UnitModel) -> bool:
    return unit_service.is_unit_fainted(unit)
