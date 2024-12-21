class_name SkillSystemController

var battle_system_controller: BattleSystemController

var current_target: int = 0
var current_target_unit: UnitModel:
	get:
		return group_target[current_target]
var current_skill_select: SkillModel

# Danh sách các target có thể được chọn
var group_target: Array[UnitModel]
# Danh sách các target mục tiêu chính của skill
var group_current_target: Array[UnitModel]

var player_group: Array[UnitModel]:
	get:
		return battle_system_controller.player_group
var enemy_group: Array[UnitModel]:
	get:
		return battle_system_controller.enemy_group

func initialize(_system: BattleSystemController):
	battle_system_controller = _system
	return

func _init(_system: BattleSystemController):
	battle_system_controller = _system
	return

func get_group_target(_skill: SkillModel, _source: UnitModel):
	if _skill == null or _source == null:
		group_target = []
		return

	# Lọc kiểu target và group các unit sẽ bị target: 
	# ==> Self -> 1 unit, Enemy / Ally -> group unit, Any -> all unit
	match _skill.target_type:
		SkillBase.TargetType.SELF:
			group_target = [_source]
		SkillBase.TargetType.ENEMY:
			group_target = enemy_group
		SkillBase.TargetType.ALLY:
			group_target = player_group
		SkillBase.TargetType.ANY:
			group_target = player_group + enemy_group
	# perform_target_mode(_skill, _source)
	return

func get_group_target_select(_skill: SkillModel, _source: UnitModel):
	if _skill == null or _source == null:
		group_current_target = []
		return
	match _skill.target_mode:
		# tất cả đối tượng
		SkillBase.TargetMode.ALL:
			group_current_target = group_target
		# Một đối tượng
		SkillBase.TargetMode.SINGLE:
			group_current_target = [group_target[current_target]]
		# Ba đối tượng
		SkillBase.TargetMode.THREE:
			var start: int = max(0, current_target - 1)
			var end: int = min(group_target.size(), current_target + 2)
			print(start, " - ", end)
			group_current_target = group_target.slice(start, end)
	print("[group_current_target]: ", group_current_target)
	return

func set_current_target(_value: int):
	if _value >= group_target.size():
		current_target = 0
		return
	
	if _value < 0:
		current_target = group_target.size() - 1
		return

	current_target = _value
	return

func perform_skill(_source: UnitModel):
	if battle_system_controller.current_unit != _source:
		return
	
	if Input.is_action_just_pressed("ui_action_1"):
		current_skill_select = _source.get_skill(0)
		print("Skill 1: ", current_skill_select)
	if Input.is_action_just_pressed("ui_action_2"):
		current_skill_select = _source.get_skill(1)
		print("Skill 2: ", current_skill_select)
	if Input.is_action_just_pressed("ui_action_3"):
		current_skill_select = _source.get_skill(2)
		print("Skill 3: ", current_skill_select)
	if Input.is_action_just_pressed("ui_action_4"):
		current_skill_select = _source.get_skill(3)
		print("Skill 4: ", current_skill_select)
	
	perform_select_target(current_skill_select, _source)
	
	if Input.is_action_just_pressed("ui_accept"):
		if current_skill_select != null:
			print(current_skill_select.skill_base.name, "Accept")
		else:
			print("Please select Skill")

func perform_select_target(_skill: SkillModel, _source: UnitModel):
	if _skill == null or _source == null:
		return

	get_group_target(_skill, _source)

	if Input.is_action_just_pressed("ui_left"):
		set_current_target(current_target - 1)
		get_group_target_select(_skill, _source)
	if Input.is_action_just_pressed("ui_right"):
		set_current_target(current_target + 1)
		get_group_target_select(_skill, _source)
	return

func run_skill(_targets: Array[UnitModel], _source: UnitModel, _skill: SkillModel) -> bool:
	return _skill.run(_targets, _source, battle_system_controller)

func reset_perform():
	group_target.clear()
	group_current_target.clear()
	current_target = 0
	current_skill_select = null
	pass
