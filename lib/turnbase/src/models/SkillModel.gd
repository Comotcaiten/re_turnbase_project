class_name SkillModel

var base: SkillBase
var element: ElementBase.Type

func _init(_base: SkillBase) -> void:
	base = _base
	element = _base.element

func use(_target: UnitModel, _source: UnitModel):
	print("[>] Skill use: target - ", _target.name, " get eff skill's source - ", _source.name)
	if base.component_if == null:
		print("[!] component_if: null")
		return false
	elif base.component_if.run_component(_target, _source, self):
		print("[!] component_if: true")
		return true
	elif base.component_else == null:
		print("[!] component_ele: null")
		return false
	elif base.component_if.run_component(_target, _source, self):
		print("[!] component_else: true")
		return true
	print("[!] component: null")
	return false
