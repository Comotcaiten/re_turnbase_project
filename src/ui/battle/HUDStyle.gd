class_name HUDStyle

# Bảng màu và hàm dựng chung cho Battle HUD.
# Mọi component dùng chung ở đây để giao diện đồng bộ, đổi màu một chỗ là đủ.

const PANEL := Color(0.06, 0.07, 0.11, 0.78)
const PANEL_LIGHT := Color(0.14, 0.16, 0.24, 0.9)
const BORDER := Color(1, 1, 1, 0.14)
const TEXT := Color(0.95, 0.96, 1.0)
const TEXT_DIM := Color(0.7, 0.73, 0.82)
const ACCENT := Color(0.35, 0.85, 1.0) # Nhân vật đang hành động
const TARGET := Color(1.0, 0.36, 0.3) # Mục tiêu đang chọn
const ALLY_TARGET := Color(0.45, 1.0, 0.55) # Mục tiêu là đồng minh (hồi máu...)
const HP_PLAYER := Color(0.36, 0.9, 0.95)
const HP_ENEMY := Color(0.92, 0.3, 0.27)
const HP_BACK := Color(0, 0, 0, 0.55)
const MP := Color(0.55, 0.6, 1.0)
const BREAK := Color(0.98, 0.98, 0.98)
const BROKEN := Color(1.0, 0.75, 0.2)
const HEAL := Color(0.45, 1.0, 0.55)
const CRIT := Color(1.0, 0.82, 0.25)
const KEY_BG := Color(0.95, 0.85, 0.45)

# Xóa con ngay khỏi cây để container không giữ node cũ thêm một frame
static func clear(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

static func box(bg: Color, radius: int = 8, border: int = 0, border_color: Color = BORDER) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(radius)
	style.set_border_width_all(border)
	style.border_color = border_color
	style.anti_aliasing = true
	return style

static func panel(bg: Color = PANEL, radius: int = 8, padding: int = 8) -> PanelContainer:
	var container := PanelContainer.new()
	var style := box(bg, radius, 1)
	style.set_content_margin_all(padding)
	container.add_theme_stylebox_override("panel", style)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return container

static func label(text: String, size: int = 14, color: Color = TEXT, outline: bool = true) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", color)
	if outline:
		node.add_theme_constant_override("outline_size", 4)
		node.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node

# Thanh máu/năng lượng dạng ProgressBar không chữ
static func bar(fill: Color, height: float = 6.0, back: Color = HP_BACK) -> ProgressBar:
	var progress := ProgressBar.new()
	progress.show_percentage = false
	progress.custom_minimum_size = Vector2(0, height)
	progress.max_value = 1.0
	progress.step = 0.0
	progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress.add_theme_stylebox_override("background", box(back, 2))
	progress.add_theme_stylebox_override("fill", box(fill, 2))
	return progress

static func set_bar_color(progress: ProgressBar, fill: Color):
	progress.add_theme_stylebox_override("fill", box(fill, 2))

# Phím tắt nhỏ kiểu "[1]" hiển thị cạnh nút
static func key_hint(text: String) -> PanelContainer:
	var container := PanelContainer.new()
	var style := box(KEY_BG, 10)
	style.content_margin_left = 6
	style.content_margin_right = 6
	container.add_theme_stylebox_override("panel", style)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(label(text, 12, Color(0.1, 0.1, 0.12), false))
	return container

# Ảnh nhân vật: dùng UnitBase.icon, không có thì ô tròn màu theo hệ kèm chữ cái đầu
static func portrait(unit: UnitModel, size: float, circle: bool = false) -> Control:
	var holder := Panel.new()
	holder.custom_minimum_size = Vector2(size, size)
	holder.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var radius: int = int(size / 2.0) if circle else 6
	holder.add_theme_stylebox_override("panel", box(Element.get_color(unit.element).darkened(0.25), radius))
	if unit.base.icon != null:
		var picture := TextureRect.new()
		picture.texture = unit.base.icon
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(picture)
		picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var initial := label(unit.name.left(1), int(size * 0.45))
		initial.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		initial.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		holder.add_child(initial)
		initial.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return holder

# Biểu tượng hiệu ứng trạng thái: chữ cái đầu + số lượt còn lại
static func status_chip(status: StatusModel) -> Control:
	var container := PanelContainer.new()
	var style := box(Color(0.25, 0.12, 0.35, 0.9), 4, 1, Color(0.8, 0.55, 1.0, 0.6))
	style.content_margin_left = 4
	style.content_margin_right = 4
	container.add_theme_stylebox_override("panel", style)
	container.tooltip_text = "%s - còn %d lượt%s" % [status.effect.name, status.turns_left, (" x%d" % status.stacks) if status.stacks > 1 else ""]
	var text: String = "%s%d" % [status.effect.name.left(2), status.turns_left]
	container.add_child(label(text, 11, TEXT, false))
	return container

static func target_mode_text(skill: SkillModel) -> String:
	if skill == null:
		return ""
	if skill.target_type == SkillBase.TargetType.SELF:
		return "Bản thân"
	var who: String = "Đồng minh" if skill.target_type == SkillBase.TargetType.ALLY else ""
	match skill.target_mode:
		SkillBase.TargetMode.ALL:
			return ("Toàn bộ " + who.to_lower()).strip_edges() if who != "" else "Toàn bộ"
		SkillBase.TargetMode.THREE:
			return "Lan tỏa (3)"
	return "Đơn mục tiêu" if who == "" else "Một đồng minh"
