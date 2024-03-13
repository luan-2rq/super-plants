extends Control

var opened_screen : Node

func _ready():
	Events.connect('open_screen', Callable(self, '_on_open_screen'))
	Events.connect('close_screen', Callable(self, '_on_close_screen'))

func _on_open_screen(name):
	for child in get_children():
		if child.name == name:
			if opened_screen != null:
				opened_screen.visible = false
			child.visible = true
			opened_screen = child

func _on_close_screen(name):
	if opened_screen.name == name:
		opened_screen.visible = false
		opened_screen = null
