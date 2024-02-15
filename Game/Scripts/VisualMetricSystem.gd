extends Node2D
class_name VisualMetricSystem

export(NodePath) var plant_control_node_path
export(NodePath) var root_control_node_path
onready var plant_control_node = get_node(plant_control_node_path)
onready var root_control_node = get_node(root_control_node_path)

export(Resource) var metric_system_config

var plant_metric_texture
var root_metric_texture

func _ready():
	_instantiate_plant_metric_units()
	_instantiate_root_metric_units()

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
	var pos = Vector2(0, plant_control_node.rect_size.y)
	var size = Vector2(metric_system_config.horizontal_size, plant_control_node.rect_size.y)
	plant_metric_texture.rect_scale = scale
	plant_metric_texture.rect_position = pos
	plant_metric_texture.rect_size = size

func _instantiate_root_metric_units():
	root_metric_texture = TextureRect.new()
	root_metric_texture.expand = true
	root_metric_texture.texture = metric_system_config.unit_texture
	root_metric_texture.stretch_mode = 2
	root_metric_texture.add_to_group("NotCentered")
	root_control_node.add_child(root_metric_texture)
	var size = Vector2(metric_system_config.horizontal_size, root_control_node.rect_size.y)
	root_metric_texture.rect_size = size
