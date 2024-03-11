extends Control
class_name OfflineProductionController

export var close_button_path : NodePath
onready var close_button : Button = get_node(close_button_path)

func _ready():
	Events.emit_signal('open_popup', name)
	close_button.connect('pressed', self, '_on_close')

func _on_close():
	Events.emit_signal('close_popup', name)
