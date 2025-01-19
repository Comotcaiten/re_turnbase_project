class_name CombatController

# Tương tác với người chơi/hệ thống và điều phối các hành động trong trận chiến

var combat_service: CombatService

# Khởi tạo controller với service
func _init():
    combat_service = CombatService.new()

# Bắt đầu trận chiến
func start_combat(group1: UnitGroupModel, group2: UnitGroupModel) -> void:
    combat_service.start_combat(group1, group2)

# Kiểm tra trận chiến có kết thúc chưa
func is_combat_over(group1: UnitGroupModel, group2: UnitGroupModel) -> bool:
    return combat_service.is_combat_over(group1, group2)

# Xử lý lượt đi của một đơn vị
func process_turn(unit: UnitModel, group1: UnitGroupModel, group2: UnitGroupModel) -> void:
    combat_service.process_turn(unit, group1, group2)
