class_name BatlleUnitArrayModel

var battle_units: Array[BattleUnitModel]

var is_player: bool

func _init(_is_player: bool):
	is_player = _is_player
	pass

func add(_battler: BattleUnitModel):
	if _battler == null:
		return
	if !_battler.is_player == is_player:
		return
	battle_units.append(_battler)

func remove(_battler: BattleUnitModel):
	if !(battle_units.has(_battler)):
		return
	var index: int = battle_units.find(_battler)
	battle_units.remove_at(index)

func get_battle_unit(_battler: BattleUnitModel):
	if _battler == null or !(_battler.is_player == is_player):
		return
	if !(battle_units.has(_battler)):
		return
	var index: int = battle_units.find(_battler)
	return battle_units[index]

func get_battle_unit_int(_index: int):
	if _index >= battle_units.size() or _index < 0:
		return
	return battle_units[_index]

static func sort_by_speed(_arr: Array[BattleUnitModel]) -> Array[BattleUnitModel]:
	# Bubbke sort
	var n = _arr.size()
	var arr = _arr
	var temp
	for i in range(0, n):
		for j in range(i, n - 1):
			if _arr[j] == null or _arr[j + 1] == null:
				return arr
			if _arr[j].unit.speed < _arr[j + 1].unit.speed:
				temp = _arr[j]
				_arr[j] = _arr[ j+ 1]
				_arr[j + 1] = temp
	# for i in _arr:
	# 	print("[", i, "] - ", "[", i.unit.speed, "]")
	return _arr
