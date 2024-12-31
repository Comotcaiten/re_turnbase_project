extends Node
class_name UnitGroupController

@export var is_group_player: bool

var id: String:
	get:
		return "UGD#" + str(self.get_instance_id()) + "/" + str(int(is_group_player))

# Quản lý các UnitModel (Only UnitModel)
var unit_group: Array[UnitModel] = []

var size: int = 0:
	get:
		return unit_group.size()

func _ready():
	get_start()
	update_position()
	pass

# Get the units in the group
func get_start() -> Array[UnitModel]:
	unit_group.clear() # Xóa mảng cũ mỗi lần gọi lại
	for child in get_children():
		if child is UnitModel:
			add_unit(child)
	return unit_group

# Filter units by fainted status
static func get_static_units_by_state(fainted: bool = false, array: Array[UnitModel] = []) -> Array[UnitModel]:
	var filtered_units: Array[UnitModel] = []
	for unit in array:
		if unit.is_fainted == fainted:
			filtered_units.append(unit)
	return filtered_units

func get_units_by_state(fainted: bool = false) -> Array[UnitModel]:
	var filtered_units: Array[UnitModel] = []
	for unit in unit_group:
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

	# # Cách viết này không tối ưu vì nó sẽ gọi hàm get_units() mỗi lần kiểm tra, dẫn đến việc tạo ra một mảng mới mỗi lần gọi.
	# for unit in get_units():
	# 	if unit.is_fainted == false:
	# 		return false
	# return true
	
	# # Cách viết tối ưu hơn
	return get_units_by_state(false).is_empty()
	# 	return true
	# return false

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

# Update unit state

# func update_unit_state():
# 	for unit in unit_group:
# 		if unit.is_fainted:
# 			unit.hide()
# 		else:
# 			unit.show()

func update_position(gap: int = 1):
	# 	TH1:
	# y = 4
	# gap = 1
	# x = 3
	# D = 4 + 3 = 7
	# 	TH2:
	# y = 4
	# gap = 3
	# x = 3
	# D = 4 + 3.3 = 4 +  9 = 13
	# => D = y + x.gap
	if gap <= 0:
		return
	
	var y: float = unit_group.size() * 1.0
	var d: int = int((y + (y - 1.0) * gap) / 2.0)
	var count: int = 0

	for i in range(-d, d + 1, gap + 1):
		unit_group[count].position.z = i
		count += 1
	return

func add_unit(_unit: UnitModel):
	if _unit == null:
		return false
	if _unit is UnitModel:
		_unit.is_player = is_group_player
		_unit.team = id
		unit_group.append(_unit)
		if _unit.get_parent() != null:
			_unit.get_parent().remove_child(_unit)
		self.add_child(_unit)
		update_position()
		return true
	return false
