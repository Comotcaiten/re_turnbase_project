extends Resource
class_name SkillLearnable

@export var base: SkillBase
@export var level: int:
    get:
        return max(level, 0)