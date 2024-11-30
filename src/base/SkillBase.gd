extends Resource
class_name SkillBase

enum TargetType {Enemy, Self}

@export var name: String

@export var target_type: TargetType

# @export_group("Components")
# @export var components: Array[SkillComponent]