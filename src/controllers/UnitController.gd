extends Node

# Giúp hỗ trợ khởi tạo và quản lý các unit model
class_name UnitController

enum Team {PLAYER, ENEMY} # Định nghĩa team_id

# Quản lý bằng cách sử dụng dictionary ==> Maps
# Vì trong game có 2 phe và bên kẻ thù và người chơi => Cần cách để biết unit thuộc phe nào

# Tiêu chí	            Cách 1: UnitGroup	        Cách 2: Dictionary team_id
# Số lượng phe	        Chỉ phù hợp với 2 phe	    Hỗ trợ nhiều phe
# Dễ hiểu & bảo trì	    Dễ hơn, trực quan hơn	    Phức tạp hơn
# Linh hoạt mở rộng	    Hạn chế (chỉ 2 nhóm)	    Có thể thêm nhiều phe
# Hiệu suất	            Tối ưu hơn khi có ít unit	Tốt hơn nếu có nhiều phe

# Dùng => Cách 1 là tạo UnitGroup => chia 2 phe tương ứng 2 UnitGroup
# Dùng => Maps để quản lý

var unit_groups: Maps = Maps.new(
	typeof(Team.PLAYER),
	typeof(UnitGroupModel),
	{
		Team.PLAYER: UnitGroupModel.new(),
		Team.ENEMY: UnitGroupModel.new()
	}
)

# Khởi tạo
func set_team(group: UnitGroupModel, type_team: Team) -> bool:
	return unit_groups.set_value(type_team, group)

# Thêm unit vào phe tương ứng
func add_unit(unit: UnitModel, team_id: Team) -> bool:
	print("- Add ", unit, " into ", team_id)
	var unit_group_model: UnitGroupModel = unit_groups.get_value(team_id) as UnitGroupModel
	return unit_group_model.add_unit(unit)

# Xóa unit khỏi phe tương ứng
func remove_unit(unit: UnitModel, team_id: Team) -> bool:
	var unit_group_model = unit_groups.get_value(team_id)
	if unit_group_model is UnitGroupModel:
		return unit_group_model.remove_unit(unit)
	return false

# Lấy danh sách unit theo phe
func get_units_by_team(team_id: Team) -> Array[UnitModel]:
	return unit_groups.get_value(team_id, UnitGroupModel.new()).get_units()

# Lấy toàn bộ unit của cả 2 phe
func get_all_units() -> Array[UnitModel]:
	return unit_groups.get_value(Team.PLAYER, UnitGroupModel.new()).get_units() + unit_groups.get_value(Team.ENEMY, UnitGroupModel.new()).get_units()

# Xóa toàn bộ unit trong game
func clear_all_units():
	for group in unit_groups.values():
		if group is UnitGroupModel:
			group.clear()
