extends Node

class_name IconUnitInBattle

@export var icon: Sprite2D = null

@export var panel_select: Panel = null

@export var panel_element: Panel = null

var panel_element_style: StyleBoxFlat = null

func _ready():
  set_select(false)

  if panel_element != null:
    panel_element_style = panel_element.get_theme_stylebox("panel").duplicate()
    panel_element.remove_theme_stylebox_override("panel")
    panel_element.add_theme_stylebox_override("panel", panel_element_style)
  pass

func set_icon(_icon: Texture):
  if icon == null:
    return
  icon.texture = _icon
  pass

func set_select(_select: bool):
  if panel_select == null:
    return
  panel_select.visible = _select
  pass

func set_element(_element: Color):
  if panel_element == null:
    return 
  print("set_element >> ", panel_element_style)
  panel_element_style.bg_color = _element
  pass