extends Resource
class_name SkillBase

@export var name: String
@export var element: CharacterBase.Element

@export_group("Targeting")
enum TargetType {SELF, ENEMY, ALLY, ANY}
@export var target_type: TargetType = TargetType.ANY

enum TargetMode {ALL, SINGLE, THREE}
@export var target_mode: TargetMode = TargetMode.ALL

@export_group("Components")
@export var components: Array[SkillComponent]

func run(_target: Array[UnitModel], _source: UnitModel, _battle_system: BattleSystemController) -> bool:
  return true