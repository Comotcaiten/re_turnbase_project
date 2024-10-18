extends Resource
class_name SkillBase

enum Target {Foe, Self}

@export var name: String
@export var element: ElementBase.Type

@export var component_if: SkillComponent
@export var component_else: SkillComponent