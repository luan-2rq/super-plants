extends Node
class_name StoreController

export var open_button_path : NodePath
export var close_button_path : NodePath
onready var open_button : Button = get_node(open_button_path)
onready var close_button : Button = get_node(close_button_path)

export var store_config : Resource

func _ready():
	pass
	#open_button.connect('pressed', self, '_on_open')
	#close_button.connect('pressed', self, '_on_close')

func _on_open():
	Events.emit_signal('open_screen', name)
	
func _on_close():
	Events.emit_signal('close_screen', name)


