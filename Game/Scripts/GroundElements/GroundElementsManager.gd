extends Node2D
class_name GroundElementsManager


export var ground_elements_config : Resource
export(NodePath) var terrain_path
onready var terrain : Terrain = get_node(terrain_path)

onready var screen_size = get_viewport().size

var ground_elements : Array

func _ready():
	var start_time = OS.get_ticks_msec() / 1000.0
	position_ground_elements()
	var end_time = OS.get_ticks_msec() / 1000.0
	print("Time to find optimal positions: "+ str(end_time - start_time))
	Events.connect("reveal_ground_element", self, "_on_reveal_ground_element")

func position_ground_elements():
	var config = (ground_elements_config as GroundElementsConfig)
	var positions
	while true:
		positions = Array()
		for groundwater_config in ground_elements_config.groundwater:
			#positions.append(Vector2(Random.range_int(terrain.bounds.min_x, terrain.bounds.max_x), Random.range_int(terrain.bounds.min_y, terrain.bounds.max_y)))
			positions.append(Vector2(Random.range_int(terrain.global_position.x + 150, terrain.global_position.x+ screen_size.x -150), Random.range_int(terrain.global_position.y+150, terrain.global_position.y + screen_size.y-150)))
		if minimum_distance_achieved(positions):
			break
	for i in range(ground_elements_config.groundwater.size()):
		var cur_groundwater = ground_elements_config.groundwater[i].scene.instance()
		cur_groundwater.config = ground_elements_config.groundwater[i]
		ground_elements.append(cur_groundwater)
		add_child(cur_groundwater)
		cur_groundwater.global_position = positions[i]
		
func closest_ground_element_direction(pos : Vector2):
	if ground_elements.size() > 0:
		var closest_ground_element = ground_elements[0]
		for i in range(1, ground_elements.size()):
			if ground_elements[i].global_position.distance_to(pos) < closest_ground_element.global_position.distance_to(pos):
				closest_ground_element = ground_elements[i]
		return (closest_ground_element.global_position-pos).normalized()
	
func minimum_distance_achieved(positions):
	for i in range(positions.size()-1):
		for j in range(1, positions.size() - i):
			var cur_position = positions[i]
			var position_to_compare_to = positions[i+j]
			var distance = cur_position.distance_to(position_to_compare_to)
			if distance < ground_elements_config.minimum_elements_distance:
				return false
	return true

func _on_reveal_ground_element(ground_element):
	ground_element.reveal()
