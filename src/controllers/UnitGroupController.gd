extends Node
class_name UnitGroupController

@export var is_group_player: bool

var id: String:
	get:
		return "UGD#" + str(self.get_instance_id()) + "/" + str(int(is_group_player))

# Quản lý các UnitModel (Only UnitModel)
var unit_group: Array[UnitModel] = []

# Get the units in the group
func get_units() -> Array[UnitModel]:
	unit_group.clear() # Xóa mảng cũ mỗi lần gọi lại
	for child in get_children():
		if child is UnitModel:
			child.is_player = is_group_player
			child.id_groups = id
			unit_group.append(child)
	return unit_group

# Filter units by fainted status
static func get_units_by_state(fainted: bool = false, array: Array[UnitModel] = []) -> Array[UnitModel]:
	var filtered_units: Array[UnitModel] = []
	for unit in array:
		if unit.is_fainted == fainted:
			filtered_units.append(unit)
	return filtered_units

static func get_groups_sort(array: Array[UnitModel] = []) -> Array[UnitModel]:
	if array.is_empty():
		return []
	array.sort_custom(sort_by_speed)
	return array

static func sort_by_speed(a: UnitModel, b: UnitModel):
	return a.speed > b.speed

# Đoạn mã này kiểm tra xem tất cả các units trong nhóm có bị fainted (ngất xỉu) hay không. Đây là cách nó hoạt động:
# Check if all units are fainted
func are_all_units_fainted() -> bool:
  # Hàm get_units_by_state được gọi với tham số true, nghĩa là nó sẽ trả về một danh sách (mảng) các units trong nhóm mà có trạng thái fainted (ngất xỉu).
  # Cụ thể, hàm này lọc mảng unit_group và chỉ giữ lại những unit mà có is_fainted == true.
  # are_all_units_fainted() sẽ trả về true nếu tất cả các units trong nhóm đều bị fainted (vì get_units_by_state(true) sẽ trả về một mảng không rỗng).
  # Nếu không phải tất cả units đều fainted (mảng chứa ít nhất một unit không fainted), hàm sẽ trả về false.
	return not get_units_by_state(true).is_empty()

# Health info method
func health_info() -> String:
	var info = "<<<<[ " + id + " ]>>>>\n"
	for unit in unit_group:
		info += unit.name + ": HP[" + str(unit.health) + "/" + str(unit.max_health) + "]\n"
	return info

# Print health info only if necessary
func print_health_info():
	if is_group_player: # print only for player group, or customize as needed
		print(health_info())
