extends Control

@onready var pages: Array[Control] = [%MainPage, %CharacterPage, %TeamPage]

func _ready():
	%NavMain.pressed.connect(show_page.bind(%MainPage))
	%NavCharacters.pressed.connect(show_page.bind(%CharacterPage))
	%NavTeam.pressed.connect(show_page.bind(%TeamPage))
	show_page(%MainPage)

func show_page(target: Control):
	for page in pages:
		page.visible = page == target
	%NavMain.button_pressed = target == %MainPage
	%NavCharacters.button_pressed = target == %CharacterPage
	%NavTeam.button_pressed = target == %TeamPage
	if target.has_method("refresh"):
		target.refresh()
