extends Node
class_name BattleUnitModel

@export var base: CharacterBase
@export var level: int
@export var is_player: bool
@export var hud: BattleHUD
@export var model3D: LoadModelBlockBench

var unit: UnitModel

func set_data():
    unit = UnitModel.new(base, level)
    load_model3D()

func load_model3D() -> bool:
    if base.model3D == null:
        print("[!] Character base dont have a model3D")
        return false
    return model3D.set_data(base.model3D)