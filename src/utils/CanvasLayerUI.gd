extends Node

class_name CanvasLayerUI

func _ready():
    get_viewport().size = DisplayServer.screen_get_size()
    pass