class_name UnitGroupService

# Quản lý nhóm các đơn vị (UnitGroupModel), 
# => Thêm/xóa đơn vị, sắp xếp lại lượt đi, và điều phối các hành động của các đơn vị trong nhóm.

# Thêm đơn vị vào nhóm
func add_unit_to_group(group: UnitGroupModel, unit: UnitModel) -> bool:
    return group.add_unit(unit)

# Xóa đơn vị khỏi nhóm
func remove_unit_from_group(group: UnitGroupModel, unit: UnitModel) -> bool:
    return group.remove_unit(unit)

# # Sắp xếp lượt đi của các đơn vị trong nhóm
# func sort_turn_order(group: UnitGroupModel) -> void:
#     group.sort_turn_order()

# # Lấy đơn vị tiếp theo trong lượt đi
# func get_next_unit(group: UnitGroupModel) -> UnitModel:
#     if group.turn_order.size() > 0:
#         return group.turn_order[0]  # Trả về đơn vị đầu tiên trong lượt đi
#     return null