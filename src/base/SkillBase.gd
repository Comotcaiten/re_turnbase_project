extends Resource

class_name SkillBase

@export var name: String
@export var id: String
@export var element: Element.Type

@export_group("Target")
enum TargetType {SELF, ENEMY, ALLY, ANY}
@export var target_type: TargetType

enum TargetMode {ALL, SINGLE, THREE}
@export var target_mode: TargetMode = TargetMode.SINGLE:
    get:
        if target_type == TargetType.SELF:
            return TargetMode.SINGLE
        return target_mode

enum TargetFainted {NONE, TRUE, FALSE}
@export var target_fainted: TargetFainted = TargetFainted.FALSE

@export_group("Components")
@export var components: Array[SkillComponent]