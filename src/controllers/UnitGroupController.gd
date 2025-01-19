class_name UnitGroupController

# Điều phối các hành động liên quan đến nhóm đơn vị (UnitGroupService).
# => Như thêm/xóa đơn vị, sắp xếp lượt đi, và xử lý các hành động trong game.

var group_service: UnitGroupService

# Khởi tạo controller với service
func _init():
    group_service = UnitGroupService.new()

# Thêm đơn vị vào nhóm
func add_unit_to_group(group: UnitGroupModel, unit: UnitModel) -> void:
    group_service.add_unit_to_group(group, unit)

# Xóa đơn vị khỏi nhóm
func remove_unit_from_group(group: UnitGroupModel, unit: UnitModel) -> void:
    group_service.remove_unit_from_group(group, unit)

# # Lấy đơn vị tiếp theo trong lượt đi
# func get_next_unit_in_turn(group: UnitGroupModel) -> UnitModel:
#     return group_service.get_next_unit(group)
