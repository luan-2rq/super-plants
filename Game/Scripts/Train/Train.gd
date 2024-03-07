extends Node
class_name Train

export(Resource) var train_config
export(NodePath) var train_front_path
export(NodePath) var collectables_controller_path
export(PackedScene) var wagon_scene

onready var train_front = get_node(train_front_path)
onready var screen_size = get_viewport().get_size()
onready var collectables_controller = get_node(collectables_controller_path)
onready var out_of_screen_offset = train_front.texture.get_size().x * train_front.scale.x + train_config.wagon_offset

var train_data : Resource
var train_wagons : Array

func _ready():
	get_viewport().connect("size_changed", self, "_on_screen_size_changed")
	#To do: get train data with save manager
	train_data = SaveManager.get_specific_save(Enums.SaveName.train_data)
	if train_data == null:
		train_data = TrainData.new()
		SaveManager.set_specific_save(Enums.SaveName.train_data, train_data)
		for i in range(train_config.n_wagons):
			var train_wagon = wagon_scene.instance()
			var train_wagon_data = TrainWagonData.new()
			train_wagon_data.init(i, false)
			train_wagon.data = train_wagon_data
			if i == 0:
				activate_wagon(train_wagon)
			train_data.train_wagons.append(train_wagon_data)
			var train_wagon_size = train_wagon.texture.get_size() * train_wagon.scale
			train_wagon.position.x -= i * (train_wagon_size.x + train_config.wagon_offset)
			train_wagons.append(train_wagon)
			self.add_child(train_wagon)
	else:
		init_from_save()

func init_from_save():
	for train_wagon_data in train_data.train_wagons:
		var train_wagon = wagon_scene.instance()
		var train_wagon_size = train_wagon.texture.get_size() * train_wagon.scale
		train_wagon.data = train_wagon_data
		train_wagon.position.x -= train_wagon_data.index * (train_wagon_size.x + train_config.wagon_offset)
		train_wagons.append(train_wagon)
		self.add_child(train_wagon)
		if train_wagon_data.active:
			activate_wagon(train_wagon)

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
	
	#Collect
	for train_wagon in train_wagons:
		if train_wagon.data.active:
			collectables_controller.collect(train_wagon.global_position.x, train_wagon.global_position.x +  train_wagon.scale.x * train_wagon.texture.get_size().x)

func get_aimed_wagon(var x_position):
	var aimed_wagon = null
	for train_wagon in train_wagons:
		if !train_wagon.data.active:
			var train_wagon_size = train_wagon.texture.get_size() * train_wagon.scale 
			var train_wagon_position = train_wagon.global_position
			if x_position > train_wagon_position.x and x_position < train_wagon_position.x + train_wagon_size.x:
				aimed_wagon = train_wagon
				break
	return aimed_wagon

func activate_wagon(train_wagon : TrainWagon):
	train_wagon.activate()
	train_wagon.data.active = true

func select_wagon(train_wagon : TrainWagon):
	train_wagon.select()

func deselect_wagon(train_wagon : TrainWagon):
	train_wagon.deselect()
