extends Node2D
class_name GroundElementsManager

export(Resource) var ground_elements_config
var ground_elements_data : GroundElementsData

export(NodePath) var terrain_path
onready var terrain : Terrain = get_node(terrain_path)

onready var screen_size = get_viewport().size
var ground_elements : Array
var available_ground_elements : Array

func _ready():
	#To do: get ground elements data from save manager
	ground_elements_data = GroundElementsData.new()
	
	if ground_elements_data.ground_elements.size() == 0:
		var start_time = OS.get_ticks_msec() / 1000.0
		var positions = generate_random_ground_elements_positions(ground_elements_config.groundwater.size())
		var end_time = OS.get_ticks_msec() / 1000.0
		print("Time to find optimal positions: "+ str(end_time - start_time))
		for pos in positions:
			instantiate_ground_element(pos)
	else:
		for ground_element in ground_elements_data.ground_elements:
			instantiate_ground_element(ground_element.pos, ground_element)

func instantiate_ground_element(pos : Vector2, data : GroundElementData = null):
	var config = (ground_elements_config as GroundElementsConfig)
	var cur_groundwater = ground_elements_config.groundwater_prefab.instance()
	if data == null:
		cur_groundwater.data = GroundwaterData.new()
		cur_groundwater.data.pos = pos
		cur_groundwater.data.size = Random.range_int(ground_elements_config.groundwater_size_range.x, ground_elements_config.groundwater_size_range.y)
		ground_elements_data.ground_elements.append(cur_groundwater.data)
	else:
		cur_groundwater.data = data
	ground_elements.append(cur_groundwater)
	if !cur_groundwater.data.revealed:
		available_ground_elements.append(cur_groundwater)
	add_child(cur_groundwater)
	cur_groundwater.global_position = pos

#Fix this algorithms so it does not take so long
func generate_random_ground_elements_positions(n: int):
	var positions
	while true:
		positions = Array()
		for i in range(n):
			#positions.append(Vector2(Random.range_int(terrain.bounds.min_x, terrain.bounds.max_x), Random.range_int(terrain.bounds.min_y, terrain.bounds.max_y)))
			positions.append(Vector2(Random.range_int(terrain.global_position.x + 150, terrain.global_position.x+ screen_size.x -150), Random.range_int(terrain.global_position.y+150, terrain.global_position.y + screen_size.y-150)))
		if minimum_distance_achieved(positions):
			break
	return positions

func closest_ground_element(pos : Vector2):
	if available_ground_elements.size() > 0:
		var closest_ground_element = available_ground_elements[0]
		for i in range(1, available_ground_elements.size()):
			if available_ground_elements[i].global_position.distance_to(pos) < closest_ground_element.global_position.distance_to(pos):
				closest_ground_element = available_ground_elements[i]
		return closest_ground_element

func minimum_distance_achieved(positions):
	for i in range(positions.size()-1):
		for j in range(1, positions.size() - i):
			var cur_position = positions[i]
			var position_to_compare_to = positions[i+j]
			var distance = cur_position.distance_to(position_to_compare_to)
			if distance < ground_elements_config.minimum_elements_distance:
				return false
	return true

func reveal_ground_element(ground_element):
	ground_element.reveal()
	var ground_element_index = available_ground_elements.rfind(ground_element)
	available_ground_elements.remove(ground_element_index)

