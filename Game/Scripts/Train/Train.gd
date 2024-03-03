extends Node
class_name Train

export(Resource) var train_config
export(NodePath) var first_wagon_path
export(NodePath) var train_front_path
onready var train_front = get_node(train_front_path)
onready var first_wagon = get_node(first_wagon_path)
onready var screen_size = get_viewport().get_size()
onready var out_of_screen_offset = train_front.texture.get_size().x * train_front.scale.x + train_config.wagon_offset

var train_data
var train_wagons : Array

func _ready():
	get_viewport().connect("size_changed", self, "_on_screen_size_changed")
	#To do: get train data with save manager
	train_data = TrainData.new()
	var train_wagon_size = first_wagon.texture.get_size() * first_wagon.scale
	train_wagons.append(first_wagon)
	for i in range(train_config.n_wagons - 1):
		var cur_train_wagon = first_wagon.duplicate()
		cur_train_wagon.position.x -= (i+1) * (train_wagon_size.x + train_config.wagon_offset)
		train_wagons.append(cur_train_wagon)
		self.add_child(cur_train_wagon)
		cur_train_wagon.visible = true
	activate_wagon(first_wagon)
	
func _on_screen_size_changed():
	screen_size = get_viewport().get_size()
	
func _physics_process(delta: float) -> void:
	#Move
	#To do: calculate velocity accordingly with train upgrades or something similar that will be contained in train_data
	var velocity = train_config.initial_velocity
	self.global_position.x += velocity * delta
	for train_wagon in train_wagons:
		if train_wagon.global_position.x > screen_size.x + out_of_screen_offset:
			train_wagon.global_position.x = -out_of_screen_offset
	if train_front.global_position.x > screen_size.x + out_of_screen_offset:
		train_front.global_position.x = -out_of_screen_offset
		
func get_aimed_wagon(var x_position):
	var aimed_wagon = null
	var train_wagon_index : int = 0
	for train_wagon in train_wagons:
		if !(train_wagon_index in train_data.active_wagons):
			var train_wagon_size = train_wagon.texture.get_size() * train_wagon.scale 
			var train_wagon_position = train_wagon.global_position
			if x_position > train_wagon_position.x and x_position < train_wagon_position.x + train_wagon_size.x:
				aimed_wagon = train_wagon
				break
		train_wagon_index += 1
	return aimed_wagon
	
func activate_wagon(train_wagon : TrainWagon):
	train_wagon.activate()
	for i in range(train_wagons.size()):
		if train_wagons[i] == train_wagon:
			train_data.active_wagons.append(i)
			break 
			
func select_wagon(train_wagon : TrainWagon):
	train_wagon.select()
		
			
func deselect_wagon(train_wagon : TrainWagon):
	train_wagon.deselect()
