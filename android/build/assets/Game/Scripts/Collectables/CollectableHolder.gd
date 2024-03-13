extends Node2D
class_name CollectableHolder

@export var collectable_scene: PackedScene
@export var config: Resource

var data : CollectableHolderData
var collectables_controller : CollectablesController

#get it from some 
var initial_spawn_rate = 10
var spawn_rate : float = 10
var elapsed_time : float = 0

func _ready() -> void:
	var instance = collectable_scene.instantiate()
	instance.collectables_controller = collectables_controller
	self.add_child(instance)
	self.rotation = data.rot
	spawn_rate = initial_spawn_rate / UpgradesManager.get_upgrade_value(Enums.UpgradeType.ProductionRateUpgrade)
	Events.connect("on_upgrade", Callable(self, "_on_production_rate_upgrade"))

func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > spawn_rate:
		elapsed_time = 0
		var instance = collectable_scene.instantiate()
		instance.collectables_controller = collectables_controller
		self.add_child(instance)

func _on_production_rate_upgrade(upgrade_type):
	if upgrade_type == Enums.UpgradeType.ProductionRateUpgrade:
		#To do: replace spawn rate for initial spawn rate
		spawn_rate = initial_spawn_rate / UpgradesManager.get_upgrade_value(Enums.UpgradeType.ProductionRateUpgrade)
