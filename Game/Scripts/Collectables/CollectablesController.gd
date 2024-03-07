extends Node
class_name CollectablesController

export var collectables_config : Resource
var collectables_data : CollectablesData
var collectables : Array

func _ready() -> void:
	collectables_data = SaveManager.get_specific_save(Enums.SaveName.collectables_data)
	if collectables_data == null:
		collectables_data = CollectablesData.new()
		SaveManager.set_specific_save(Enums.SaveName.collectables_data, collectables_data)
	else:
		for collectable_data in collectables_data.collectables:
			instantiate_collectable(collectable_data)

func instantiate_collectable(collectable_data):
	var collectable_instance = collectables_config.collectable_prefab.instance()
	collectables.append(collectable_instance)
	collectable_instance.data = collectable_data
	self.add_child(collectable_instance)
	collectable_instance.global_position = collectable_instance.data.pos

#Only add the collectable when it has reached the ground
func add_collectable(pos, price, instance):
	var collectable_data = CollectableData.new()
	collectable_data.init(pos, price)
	collectables_data.collectables.append(collectable_data)
	collectables.append(instance)
	instance.data = collectable_data
	#To do: make all collectables its child, to do that we need to fix the scale problem
	#instance.get_parent().remove_child(instance)
	#self.add_child(instance)

func collect(min_x, max_x):
	var i = 0
	while i < collectables.size():
		if collectables[i].is_collectable:
			if is_in_range(collectables[i].global_position.x, min_x, max_x):
				collectables[i].collect()
				collectables.remove(i)
				i-=1
		i+=1

func collect_all():
	for collectable in collectables:
		collectable.collect()

func is_in_range(value, min_x : float, max_x: float):
	if value > min_x and value < max_x:
		return true
	else:
		return false

# Tree knows which collectables does it have and instantiate then as needed, but we need to have control over the ones that were spawened and not collected
