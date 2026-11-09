class_name Role

enum Type {Fighter, Tanker, Mage, Support, Assassin, Marksman}

const DISPLAY_NAMES := {
	Type.Fighter: "Đấu sĩ",
	Type.Tanker: "Đỡ đòn",
	Type.Mage: "Pháp sư",
	Type.Support: "Hỗ trợ",
	Type.Assassin: "Sát thủ",
	Type.Marksman: "Xạ thủ",
}

static func get_display_name(role: Type) -> String:
	return DISPLAY_NAMES.get(role, "")
