extends Node
class_name BattleSystemController

enum State {StartState, UnitState, ActionState, SkillState, EndState}
enum Cycle {StartCycle, InsideCycle, EndCycle}

@export var unit_combatant_player: UnitCombatantController
@export var unit_combatant_enemy: UnitCombatantController

@export var camera_point: Node

# Các thông số, dữ liệu trong trận đấu
# - Lấy tất cả các unit từ cả hai bên
var unit_combatants: Array[UnitModel]:
	get:
		return (unit_combatant_player.get_all_unit() + unit_combatant_enemy.get_all_unit())
# - các trạng thái cycle, state
var state: State
var cycle: Cycle

var count: float


# Khởi tạo
func initialize():
	unit_combatant_player.initialize()
	unit_combatant_enemy.initialize()

# Bắt đầu Game
func _ready():
	initialize()
	print(unit_combatants)

	# Bắt đầu cycle đầu tiên
	print(Cycle.find_key(cycle))
	pass

# Update Game
func _process(_delta):

	# match cycle:
	# 	Cycle.StartCycle:
	# 		print("Start Cycle")
	# 	Cycle.InsideCycle:
	# 		print("Inside Cycle")
	# 		match state:
	# 			State.StartState:
	# 				print("Inside Cycle - Start State")
	# 			State.UnitState:
	# 				print("Inside Cycle - Unit State")
	# 			State.ActionState:
	# 				print("Inside Cycle - Action State")
	# 			State.SkillState:
	# 				print("Inside Cycle - Skill State")
	# 			State.EndState:
	# 				print("Inside Cycle - End State")
	# 	Cycle.EndCycle:
	# 		print("End Cycle")

	pass

# Cycle: là các vòng / wave của các trận đấu - Vòng lặp
# Start Cycle: bắt đầu cycle
func perform_start_cycle():
	cycle = Cycle.InsideCycle
	pass
# Inside Cycle: các sự kiện bên trong cycle
func perform_inside_cycle():
	pass
# End Cycle: bắt kết thúc cycle
func perform_end_cycle():
	cycle = Cycle.StartCycle
	pass

# State: là các trạng thái lần lượt bên trong một cycle
# Start State: bắt đầu state bằng việc kiểm tra danh sách trước
func perform_start_state():
	state = State.UnitState
	pass
# Unit State: state này xem unit nào đến lượt
func perform_unit_state():
	state = State.ActionState
	pass
# Action State: state này mở form (nếu là lượt player) gồm các nút: Attack / Skill / Bag / Run
func perform_action_state():
	state = State.SkillState
	pass
# Skill State: state này mở nếu nhấn nút mở form chọn skill
func perform_skill_state():
	state = State.EndState
	pass
# End State: state kết thúc
func perform_end_state():
	state = State.StartState
	pass