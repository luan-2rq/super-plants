extends Control

export var open_button_path : NodePath
export var close_button_path : NodePath
onready var open_button : Button = get_node(open_button_path)
onready var close_button : Button = get_node(close_button_path)

export var v_box_container_path : NodePath
onready var v_box_container : Node = get_node(v_box_container_path)

export var upgrades_config : Resource
var upgrades_data : Resource
export(PackedScene) var upgrade_cell

func _ready():
	open_button.connect('pressed', self, '_on_open')
	close_button.connect('pressed', self, '_on_close')
	for upgrade in upgrades_config.upgrades:
		var upgrade_cell_instance = upgrade_cell.instance()
		v_box_container.add_child(upgrade_cell_instance)

func _on_open():
	Events.emit_signal('open_popup', name)
	
func _on_close():
	Events.emit_signal('close_popup', name)
