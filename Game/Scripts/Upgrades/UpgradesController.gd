extends Control

export var open_button_path : NodePath
export var close_button_path : NodePath
onready var open_button : Button = get_node(open_button_path)
onready var close_button : Button = get_node(close_button_path)

func _ready():
	open_button.connect('pressed', self, '_on_open')
	close_button.connect('pressed', self, '_on_close')

func _on_open():
	Events.emit_signal('open_popup', name)
	
func _on_close():
	Events.emit_signal('close_popup', name)
