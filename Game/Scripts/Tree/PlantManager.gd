extends Control
class_name PlantManager

export(NodePath) var plant_path 
export(NodePath) var plant_scroll_container_path
export(NodePath) var plant_scroll_container_control_path

onready var plant : NormalTreeNode = get_node(plant_path)
onready var plant_scroll_container =  get_node(plant_scroll_container_path)
onready var plant_scroll_container_control = get_node(plant_scroll_container_control_path)

var grow_data

func _ready():
	#To do: get grow data from save manager
	grow_data = GrowData.new()
	Events.connect("root_full_grown", self, "_on_root_full_grown")
	Events.connect("on_grow", self, "_on_plant_grow")

func _process(delta):
	if grow_data.height_to_grow > grow_data.height:
		plant.grow_tree()

func _on_plant_grow(tree_type, max_point):
	grow_data.height = max_point.y
	
func _on_root_full_grown(branch_data : BranchData):
	if branch_data.overlapping_ground_element == null:
		return
	else:
		if branch_data.overlapping_ground_element is Groundwater:
			#To do: remove the hardcoded pumping rate
			branch_data.overlapping_ground_element.pump(0.05)
			grow_data.height_to_grow += branch_data.overlapping_ground_element.data.size
			print(grow_data.height_to_grow)
		else: 
			return
