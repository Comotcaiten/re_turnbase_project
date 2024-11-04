extends Node
class_name SkillsController

# <Database>
var unit_model: UnitModel
# </Database>

# <Skills>
var skills: Array[SkillModel]
# </Skills>

# <Init> Khởi tạo
func initialize(_unit_model: UnitModel):
    if _unit_model == null:
        return false
    unit_model = _unit_model
    # print("[SkillsController] unit_model: ", unit_model)
    load_data()
    return true

func load_data():
    for skill in unit_model.base.skills:
        if skill == null:
            continue
        skills.append(SkillModel.new(skill))
# </Init>

# <Run>
func run(_target: UnitModel, _source: UnitModel):
    return false
# </Run>

# <Get>
func get_skills() -> Array[SkillModel]:
    # print("[SkillsController] Get skills")
    return skills

func get_skill_by_id(_id: int) -> SkillModel:
    if _id < 0 or _id >= skills.size():
        return
    return skills[_id]

func get_random_skill() -> SkillModel:
    return skills[randi() % skills.size()]

func has_by_skill_base(_skill: SkillModel):
    for skill in skills:
        if skill.base == _skill.base:
            return true
    return false
    
# </Get>

# <Set>

# </Set>

# <Update>

# </Update>