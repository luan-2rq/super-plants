extends Node2D
class_name CollectableHolder

export(PackedScene) var collectable_scene
export(Resource) var config

var data
var collectables_controller : CollectablesController

#To do: get this value from config
#seconds
var spawn_rate = 3
var elapsed_time : float = 0

func _ready() -> void:
	#to do: instantiate collectable progressively in code
	var instance = collectable_scene.instance()
	self.add_child(instance)
	#To do: get price from config and prefab too
	collectables_controller.add_collectable(instance.global_position, 100, instance)
	self.rotation = data.rot
	#self.get_p.remove_child(get_child(0))

func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > spawn_rate:
		elapsed_time = 0
		var instance = collectable_scene.instance()
		self.add_child(instance)
		collectables_controller.add_collectable(instance.global_position, 100, instance)
