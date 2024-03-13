extends Control

var opened_popup : Node

func _ready():
	Events.connect('open_popup', Callable(self, '_on_open_popup'))
	Events.connect('close_popup', Callable(self, '_on_close_popup'))

func _on_open_popup(name):
	for child in get_children():
		if child.name == name:
			if opened_popup != null:
				opened_popup.visible = false
			child.visible = true
			opened_popup = child

func _on_close_popup(name):
	if opened_popup.name == name:
		opened_popup.visible = false
		opened_popup = null
