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

	if battle_system_controller == null:
		return
	
	if battle_system_controller.db_groups_unit == null or battle_system_controller.db_groups_unit.db.is_empty():
		return

	if !battle_system_controller.db_groups_unit.size == 2:
		return

	# Lọc kiểu target và group các unit sẽ bị target: 
	# ==> Self -> 1 unit, Enemy / Ally -> group unit, Any -> all unit
	match _skill.target_type:
		SkillBase.TargetType.SELF:
			group_target = [_source]
		SkillBase.TargetType.ENEMY:
			# battle_system_controller.db_groups_unit.get
			var enemy_group: Array[UnitModel]
			for id in battle_system_controller.db_groups_unit.db:
				if id != _source.id_groups:
					enemy_group = get_groups_from_maps(id)
			group_target = enemy_group
		SkillBase.TargetType.ALLY:
			group_target = get_groups_from_maps(_source.id_groups)
		SkillBase.TargetType.ANY:
			for id in battle_system_controller.db_groups_unit.db:
				group_target.append_array(get_groups_from_maps(id))
			return
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
			print(current_skill_select.skill_base.name, " Accept")
			print(current_skill_select.run(group_current_target, _source, battle_system_controller))
			print("Run Done")
		else:
			print("Skill Null")
		perform_after()

func perform_after():
	battle_system_controller.perform_after_every_thing()
	battle_system_controller.enemy_unit_group_model.health_info()

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

func reset_perform():
	group_target.clear()
	group_current_target.clear()
	current_target = 0
	current_skill_select = null
	pass

func get_groups_from_maps(_id: Variant = null) -> Array[UnitModel]:
	if battle_system_controller.db_groups_unit.get_val(_id) == null:
		return []
	return battle_system_controller.db_groups_unit.get_val(_id).group