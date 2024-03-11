extends Control
class_name BoostsController

export var open_button_path : NodePath
export var close_button_path : NodePath
onready var open_button : Button = get_node(open_button_path)
onready var close_button : Button = get_node(close_button_path)

export var v_box_container_path : NodePath
onready var v_box_container : Node = get_node(v_box_container_path)

export var boosts_config : Resource
var boosts_data : Resource
#To do: should it be in config?
export(PackedScene) var boost_cell

func _ready():
	#open_button.connect('pressed', self, '_on_open')
	close_button.connect('pressed', self, '_on_close')
	#for boost in boosts_config.boosts:
		#var boost_cell_instance = boost_cell.instance()
		#v_box_container.add_child(boost_cell_instance)

func _on_open():
	Events.emit_signal('open_screen', name)
	
func _on_close():
	Events.emit_signal('close_screen', name)
