extends Node2D
class_name GroundElementsController

onready var screen_size = get_viewport().size

export var ground_elements_config : Resource
var terrain : Terrain

func _ready():
	terrain = get_parent()
	var start_time = OS.get_ticks_msec() / 1000.0
	position_ground_elements()
	var end_time = OS.get_ticks_msec() / 1000.0
	print("Time to find optimal positions: "+ str(end_time - start_time))

func position_ground_elements():
	var config = (ground_elements_config as GroundElementsConfig)
	var positions
	while true:
		positions = Array()
		for groundwater_config in ground_elements_config.groundwater:
			#positions.append(Vector2(Random.range_int(terrain.bounds.min_x, terrain.bounds.max_x), Random.range_int(terrain.bounds.min_y, terrain.bounds.max_y)))
			positions.append(Vector2(Random.range_int(get_parent().global_position.x, get_parent().global_position.x+ screen_size.x), Random.range_int(get_parent().global_position.y, get_parent().global_position.y + screen_size.y)))
		if minimum_distance_achieved(positions):
			break
	for i in range(ground_elements_config.groundwater.size()):
		var cur_groundwater = ground_elements_config.groundwater[i].prefab.instance()
		add_child(cur_groundwater)
		cur_groundwater.global_position = positions[i]
		
func minimum_distance_achieved(positions):
	for i in range(positions.size()-1):
		for j in range(1, positions.size() - i):
			var cur_position = positions[i]
			var position_to_compare_to = positions[i+j]
			var distance = cur_position.distance_to(position_to_compare_to)
			if distance < ground_elements_config.minimum_elements_distance:
				return false
	return true

