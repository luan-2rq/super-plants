extends Node2D
class_name VisualMetricSystem

@export var scroll_controller_path: NodePath
@export var plant_control_node_path: NodePath
@export var root_control_node_path: NodePath
@onready var scroll_controller = get_node(scroll_controller_path)
@onready var plant_control_node = get_node(plant_control_node_path)
@onready var root_control_node = get_node(root_control_node_path)

@export var metric_system_config: Resource

var plant_metric_texture
var root_metric_texture

func _ready():
	pass
	#_instantiate_plant_metric_units()
	#_instantiate_root_metric_units()

#metric system main points

func _instantiate_plant_metric_units():
	plant_metric_texture = TextureRect.new()
	plant_metric_texture.expand = true
	plant_metric_texture.texture = metric_system_config.unit_texture
	plant_metric_texture.stretch_mode = 2
	plant_metric_texture.add_to_group("NotCentered")
	plant_control_node.add_child(plant_metric_texture)
	plant_control_node.move_child(plant_metric_texture, 0)
	var scale = Vector2(1, -1)
	var pos = Vector2(0, plant_control_node.size.y)
	var size = Vector2(metric_system_config.horizontal_size, plant_control_node.size.y)
	plant_metric_texture.scale = scale
	plant_metric_texture.position = pos
	plant_metric_texture.size = size

func _instantiate_root_metric_units():
	root_metric_texture = TextureRect.new()
	root_metric_texture.expand = true
	root_metric_texture.texture = metric_system_config.unit_texture
	root_metric_texture.stretch_mode = 2
	root_metric_texture.add_to_group("NotCentered")
	root_control_node.add_child(root_metric_texture)
	var size = Vector2(metric_system_config.horizontal_size, root_control_node.size.y)
	root_metric_texture.size = size
