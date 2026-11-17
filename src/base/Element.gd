class_name Element

enum Type {PHYSICAL, FIRE, WATER}

# CHART[hệ tấn công][hệ phòng thủ] = hệ số; cặp không khai báo là 1.0
const CHART := {
	Type.FIRE: {Type.WATER: 0.5},
	Type.WATER: {Type.FIRE: 2.0},
}

const DISPLAY_NAMES := {
	Type.PHYSICAL: "Vật lý",
	Type.FIRE: "Hỏa",
	Type.WATER: "Thủy",
}

const COLORS := {
	Type.PHYSICAL: Color(0.55, 0.55, 0.6),
	Type.FIRE: Color(0.85, 0.3, 0.2),
	Type.WATER: Color(0.2, 0.5, 0.9),
}

static func get_display_name(element: Type) -> String:
	return DISPLAY_NAMES.get(element, "")

static func get_color(element: Type) -> Color:
	return COLORS.get(element, Color.WHITE)

static func get_multiplier(attacker: Type, defender: Type) -> float:
	return CHART.get(attacker, {}).get(defender, 1.0)