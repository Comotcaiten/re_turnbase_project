class_name Element

enum Type {PHYSICAL, FIRE, WATER}

# CHART[hệ tấn công][hệ phòng thủ] = hệ số; cặp không khai báo là 1.0
const CHART := {
	Type.FIRE: {Type.WATER: 0.5},
	Type.WATER: {Type.FIRE: 2.0},
}

static func get_multiplier(attacker: Type, defender: Type) -> float:
	return CHART.get(attacker, {}).get(defender, 1.0)