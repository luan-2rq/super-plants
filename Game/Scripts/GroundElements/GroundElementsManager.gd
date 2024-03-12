extends Node2D
class_name GroundElementsManager

export(Resource) var ground_elements_config
var ground_elements_data : GroundElementsData

export(NodePath) var terrain_path
onready var terrain : Terrain = get_node(terrain_path)

export(NodePath) var arrows_controller_path
onready var arrows_controller : ArrowsController = get_node(arrows_controller_path)

export(NodePath) var root_scroll_container_path
onready var root_scroll_container = get_node(root_scroll_container_path)

onready var screen_size = get_viewport().size
var ground_elements : Array
var available_ground_elements : Array

func _ready():
	terrain.initialize()
	ground_elements_data = SaveManager.get_specific_save(Enums.SaveName.ground_elements_data)

	if ground_elements_data == null:
		ground_elements_data = GroundElementsData.new()
		SaveManager.set_specific_save(Enums.SaveName.ground_elements_data, ground_elements_data)
		var start_time = OS.get_ticks_msec() / 1000.0
		var positions = generate_random_ground_elements_positions(ground_elements_config.groundwater.size())
		var end_time = OS.get_ticks_msec() / 1000.0
		print("Time to find optimal positions: "+ str(end_time - start_time))
		var i = 0
		for pos in positions:
			instantiate_ground_element(pos, i)
			i+=1
	else:
		for ground_element in ground_elements_data.ground_elements:
			instantiate_ground_element(ground_element.pos, ground_element.index, ground_element)
	arrows_controller.initialize()
	root_scroll_container.connect("resized", self, "_on_resize")
func instantiate_ground_element(pos : Vector2, index : int = 0, data : GroundElementData = null):
	var config = (ground_elements_config as GroundElementsConfig)
	var cur_groundwater = ground_elements_config.groundwater_prefab.instance()
	
	#Logic to spawn ground elements
	if data == null:
		cur_groundwater.data = GroundwaterData.new()
		cur_groundwater.data.pos = pos
		var size = Random.range_int(ground_elements_config.groundwater_size_range.x, ground_elements_config.groundwater_size_range.y)
		cur_groundwater.data.remaining_water = size
		cur_groundwater.data.index = index
		cur_groundwater.data.size = size
		ground_elements_data.ground_elements.append(cur_groundwater.data)
	else:
		cur_groundwater.data = data
	ground_elements.append(cur_groundwater)
	cur_groundwater.global_position = pos
	self.add_child(cur_groundwater)
	if !cur_groundwater.data.revealed:
		available_ground_elements.append(cur_groundwater)

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

func _on_resize():
	for ground_element in ground_elements:
		if ground_element.data.revealed:
			ground_element.reveal()
