extends Resource
class_name SkillBase

@export var name: String
@export var element: CharacterBase.Element

var id: String:
  get:
    return str(self.get_instance_id())

var active: bool = true

@export_group("Targeting")
enum TargetType {SELF, ENEMY, ALLY, ANY}
@export var target_type: TargetType = TargetType.ANY

enum TargetMode {ALL, SINGLE, THREE}
@export var target_mode: TargetMode = TargetMode.ALL

enum TargetFainted {NONE, TRUE, FALSE}
@export var target_fainted: TargetFainted = TargetFainted.FALSE

@export_group("Components")
@export var components: Array[SkillComponent]
enum BreakPointMode {None, True, False}
@export var break_point: BreakPointMode

func _init():
  name = "None"
  active = false
  pass