class_name CombatService

# Xử lý tất cả các logic liên quan đến chiến đấu giữa các đơn vị trong một trận đấu. 
# Bao gồm việc tính toán sát thương, sử dụng kỹ năng, và xác định lượt của các đơn vị trong trận chiến.

var unit_group_service: UnitGroupService  # Quản lý nhóm đơn vị trong trận chiến

# Khởi tạo service với các đối tượng khác
func _init():
    unit_group_service = UnitGroupService.new()

# Bắt đầu trận chiến (giả định là giữa hai nhóm)
func start_combat(group1: UnitGroupModel, group2: UnitGroupModel) -> void:
    # Đặt lại lượt của cả hai nhóm
    unit_group_service.sort_turn_order(group1)
    unit_group_service.sort_turn_order(group2)

    # Chạy vòng lặp combat (đơn giản cho ví dụ)
    while not is_combat_over(group1, group2):
        var current_unit = unit_group_service.get_next_unit(group1)
        if current_unit != null and not current_unit.is_fainted:
            process_turn(current_unit, group1, group2)

        # Sắp xếp lại lượt sau mỗi lượt
        unit_group_service.sort_turn_order(group1)
        unit_group_service.sort_turn_order(group2)

# Kiểm tra xem trận chiến có kết thúc không
func is_combat_over(group1: UnitGroupModel, group2: UnitGroupModel) -> bool:
    var all_fainted1 = true
    var all_fainted2 = true

    # Kiểm tra xem tất cả đơn vị trong nhóm 1 có ngất không
    for unit in group1.db:
        if not unit.is_fainted:
            all_fainted1 = false
            break

    # Kiểm tra xem tất cả đơn vị trong nhóm 2 có ngất không
    for unit in group2.db:
        if not unit.is_fainted:
            all_fainted2 = false
            break

    return all_fainted1 or all_fainted2  # Nếu một nhóm hoàn toàn ngất, trận chiến kết thúc

# Xử lý lượt đi của một đơn vị
func process_turn(unit: UnitModel, group1: UnitGroupModel, group2: UnitGroupModel) -> void:
    # Giả sử đơn vị sẽ tấn công mục tiêu (target) trong trận chiến
    var target = select_target(unit, group1, group2)
    if target != null and not target.is_fainted:
        var damage = calculate_damage(unit, target)
        apply_damage(target, damage)
        print(unit.name + " tấn công " + target.name + " với sát thương: " + str(damage))

    # Có thể thêm các hành động khác ở đây như sử dụng kỹ năng
    # skill_service.use_skill(unit, skill, target)

# Chọn mục tiêu tấn công (giả sử chọn ngẫu nhiên một mục tiêu còn sống)
func select_target(attacker: UnitModel, group1: UnitGroupModel, group2: UnitGroupModel) -> UnitModel:
    var potential_targets = []
    if group1.db.size() > 0:
        for unit in group1.db:
            if not unit.is_fainted:
                potential_targets.append(unit)

    if group2.db.size() > 0:
        for unit in group2.db:
            if not unit.is_fainted:
                potential_targets.append(unit)

    if potential_targets.size() > 0:
        return potential_targets[randi() % potential_targets.size()]
    return null

# Tính toán sát thương giữa 2 đơn vị
func calculate_damage(attacker: UnitModel, target: UnitModel) -> int:
    var base_damage = attacker.attack - target.defense
    base_damage = max(base_damage, 1)  # Đảm bảo rằng sát thương không nhỏ hơn 1
    var damage_modifier = 1.0

    # Thêm các yếu tố như yếu tố nguyên tố (elemental) hoặc kỹ năng ở đây
    if attacker.element == target.element:
        damage_modifier = 1.5  # Ví dụ: nếu yếu tố giống nhau, sát thương tăng 50%

    return int(base_damage * damage_modifier)

# Áp dụng sát thương lên đơn vị mục tiêu
func apply_damage(target: UnitModel, damage: int) -> void:
    target.stats_base.hp -= damage
    if target.stats_base.hp <= 0:
        target.is_fainted = true
        print(target.name + " đã ngất!")
