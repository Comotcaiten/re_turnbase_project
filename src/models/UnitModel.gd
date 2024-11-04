extends Node
class_name UnitModel

@export var base: CharacterBase
@export var level: int:
    get:
        return max(0, level)

# <In Battle>
@export var is_player: bool
var is_fainted: bool

var speed_changed: bool = false  # Thêm biến này để theo dõi sự thay đổi tốc độ
# </In Battle>

# <Controller>
@export var stats_controller: StatsController
@export var skills_controller: SkillsController
# </Controller>

# <Init> Khởi tạo
# # Version 1
# func initialize(_base: CharacterBase, _level: int):
#     base = _base
#     level = _level
#     stats_controller.initialize(self)

# # Version 2
func initialize() -> bool:
    # print("[UnitModel] ", name)
    if base == null:
        return false
    stats_controller.initialize(self)
    skills_controller.initialize(self)
    return true
# </Init>

# <Get>
func get_skills() -> Array[SkillModel]:
    return skills_controller.get_skills()

func get_skill_by_id(_id: int) -> SkillModel: 
    return skills_controller.get_skill_by_id(_id)

func get_random_skill():
    return skills_controller.get_random_skill()

func has_skill(_skill: SkillModel):
    return skills_controller.has_by_skill_base(_skill)
# </Get>

# <Battle>
func use_skill(_target: UnitModel, _skill: SkillModel):
    if _target == null or _skill == null:
        return false
    print ("[UnitModel] use_skill: ", _skill.base.name, " on ", _target.name)
    var is_run: bool = _skill.run(_target, self)
    if is_run:
        on_signal_use_skill(_target, _skill)
    return is_run

func take_damage(_source: UnitModel, _skill: SkillModel):
    if _skill.damage_detail.source == null:
        return
    var detail = _skill.damage_detail
    var defense = stats_controller.defense * 1.0
    var damage = detail.damage * 1.0
    print("[Damage Before] ", damage)
    if detail.true_damage:
        defense = 1.0
    damage = int(damage / defense)
    print("[Defense] ", defense)
    stats_controller.set_health(stats_controller.health - damage)
    if stats_controller.health <= 0:
        on_signal_die(_source)
    print("[UnitModel] ", name, " take ", damage, " DMG")
    print("[UnitModel] ", name, " health: ", stats_controller.health, "/", stats_controller.max_health)
    
# </Battle>

# <On Signal> Get - Set
func on_signal_use_skill(_target: UnitModel, _skill: SkillModel):
    # # Gọi khi unit sử dụng skill
    print("[UnitModel] on_signal_use_skill")
    # if _skill and _target:
    #     print("[UnitModel] Using skill on target.")
    #     _target.on_signal_take_damage(_skill, self)
    #     if _target.is_fainted:
    #         on_signal_killed(_target)
    pass

func on_signal_take_damage(_skill: SkillModel, _source: UnitModel):
    # # Gọi khi unit nhận sát thương từ skill
    print("[UnitModel] on_signal_take_damage")
    # if _skill:
    #     stats_controller.apply_damage(_skill.damage)
    #     print("[UnitModel] Taking damage.")
    #     if stats_controller.health <= 0:
    #         is_fainted = true
    #         on_signal_die(_source)
    pass

func on_signal_take_effect(_skill: SkillModel, _source: UnitModel):
    # # Gọi khi unit chịu ảnh hưởng từ skill (debuff, buff, ...)
    print("[UnitModel] on_signal_take_effect")
    # if _skill:
    #     stats_controller.apply_effect(_skill.effect)
    #     print("[UnitModel] Effect applied.")
    pass

func on_signal_die(_source: UnitModel):
    # Gọi khi unit chết
    print("[UnitModel] on_signal_died.")
    print("[UnitModel] Unit has died.")
    is_fainted = true
    # Có thể thêm các logic như xóa unit khỏi trận đấu
    pass

func on_signal_killed(_target: UnitModel):
    # Gọi khi unit giết một unit khác
    print("[UnitModel] Target has been killed.")
    # Thực hiện các hành động khi giết địch như tăng điểm kinh nghiệm, kích hoạt kỹ năng
    pass

func on_signal_set_health(_new_health: int, _source: UnitModel):
    # Gọi để cập nhật lại health của unit
    stats_controller.set_health(_new_health)
    print("[UnitModel] Health set to ", _new_health)
    if stats_controller.health <= 0:
        on_signal_die(_source)
    pass
# </On Signal>

# <Update>
# </Update>