extends Control
class_name PlantManager

@export var plant_path: NodePath 
@export var plant_scroll_container_path: NodePath
@export var plant_scroll_container_control_path: NodePath
@export var ground_elements_manager_path: NodePath

@onready var plant : NormalTreeNode = get_node(plant_path)
@onready var plant_scroll_container =  get_node(plant_scroll_container_path)
@onready var plant_scroll_container_control = get_node(plant_scroll_container_control_path)
@onready var ground_elements_manager = get_node(ground_elements_manager_path)

var grow_data

func _ready():
	#To do: get grow data from save manager
	grow_data = SaveManager.get_specific_save(Enums.SaveName.grow_data)
	if grow_data == null:
		grow_data = GrowData.new()
		SaveManager.set_specific_save(Enums.SaveName.grow_data, grow_data)
	Events.connect("root_full_grown", Callable(self, "_on_root_full_grown"))
	Events.connect("on_grow", Callable(self, "_on_plant_grow"))
	Events.connect("on_emptied_groundwater", Callable(self, "_on_groundwater_emptied"))

func _process(delta):
	if grow_data.height_to_grow > grow_data.height:
		plant.grow_tree(delta*grow_data.growth_velocity)

func _on_plant_grow(tree_type, max_point):
	grow_data.height = max_point.y

func _on_root_full_grown(branch_data : BranchData):
	if branch_data.overlapping_ground_element_index == -1:
		return
	else:
		var ground_element = ground_elements_manager.ground_elements[branch_data.overlapping_ground_element_index]
		if ground_element is Groundwater:
			#To do: remove the hardcoded pumping rate
			ground_element.pump(5)
			#To do: remove hardcoded additional velocity
			grow_data.growth_velocity += 5
			grow_data.height_to_grow += ground_element.data.size
		else: 
			return

func _on_groundwater_emptied(groundwater):
	#To do: remove hardcoded additional velocity
	grow_data.growth_velocity -= 5
