extends Node

class_name BattleSystem

@export var node_groups: Array[UnitGroupNode] = []
@export var unit_controller: UnitController = UnitController.new()

var context: String = "Hello"
func _ready():

    print("Khởi tạo các team/group:")
    if node_groups.size() == 2:
        for group in node_groups:
            print("* Node group: ", group)
            unit_controller.set_team(group.unit_group, group.team)
            for unit_node in group.unit_nodes:
                unit_controller.add_unit(UnitModel.new(unit_node.base, unit_node.level), group.team)
    else:
        print("- Lỗi Node groups size != 2.")

    # # Test Debug UnitController    
    # print("<> Debug: In tất cả unit ra: ", unit_controller.get_all_units())
    # print("<> Debug: In tát cả unit từ team player: ", unit_controller.get_units_by_team(UnitController.Team.PLAYER))
    # var unit_rand: UnitModel = unit_controller.get_units_by_team(UnitController.Team.PLAYER)[randi() % unit_controller.get_units_by_team(UnitController.Team.PLAYER).size()]
    # print("<> Debug: Xoá một unit bất kì: ", unit_controller.remove_unit(unit_rand, UnitController.Team.PLAYER), '\n', unit_controller.get_all_units())
    # print("<> Debug: Clear het tat ca: ", unit_controller.clear_all_units(), '\n', unit_controller.get_all_units())
    # var unit_add: UnitModel = UnitModel.new(UnitBase.new(), 10)
    # print("<> Debug: Thêm một unit vào phe player: ", unit_controller.add_unit(unit_add, UnitController.Team.PLAYER), '\n', unit_controller.get_all_units())
    pass