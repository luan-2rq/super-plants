extends Resource
class_name Save

@export var player_data : Resource
@export var plant_data : Resource
@export var root_data : Resource
@export var ground_elements_data : Resource
@export var train_data : Resource
@export var checkpoints_data : Resource
@export var collectables_data : Resource
@export var settings_data : Resource
@export var grow_data : Resource
@export var upgrades_data : Resource

func get_save(name):
	for property in get_property_list():
		if property.name == name:
			return get(property.name)
	printerr("Save property not found")
	return null
