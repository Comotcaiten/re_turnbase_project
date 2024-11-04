class_name SkillModel

var base: SkillBase
var counter_components: int

var damage_detail: DamageDetailModel = DamageDetailModel.new(null, 0, 0)

func initialize(_base: SkillBase):
    base = _base

func _init(_base: SkillBase):
    initialize(_base)
    pass

func run(_target: UnitModel, _source: UnitModel):
    if base.components.is_empty():
        return false
    for child in base.components:
        counter_components += 1
        if child == null:
            continue
        if child.active(_target, _source, self):
            return true
    return false