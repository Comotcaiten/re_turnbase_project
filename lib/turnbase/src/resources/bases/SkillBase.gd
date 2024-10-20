extends Resource
class_name SkillBase

# enum Target {Foe, Self}
enum Trigger {Cast, Kill, Death, TookSkillDamage, Land}

@export var name: String
@export var element: ElementBase.Type

@export var trigger: Trigger

@export var component_if: SkillComponent
@export var component_else: SkillComponent
