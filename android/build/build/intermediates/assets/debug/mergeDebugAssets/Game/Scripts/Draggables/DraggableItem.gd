extends Node2D
class_name DraggableItem

var floating_text_scene = preload("res://Game/Prefabs/FloatingText.tscn")

var config : DraggableConfig
var terrain : Terrain
var ground_elements_manager : GroundElementsManager
var train : Train
var arrow_controller : ArrowsController

#Every inherited implementation must also call this function, when overriding this fucntion.
# This functions returns wether it was possible or not to complete action
func start_action():
	var has_enough_currency = EconomyManager.remove_currency(config.currency_type, BigNumber.new(config.price, 0))
	
	var floating_text = floating_text_scene.instantiate()
	get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
	floating_text.z_index = 5
	floating_text.global_position = self.global_position
	
	if has_enough_currency:
		floating_text.display_text(str(-config.price), Color(1, 0, 0, 1))
	else:
		floating_text.display_text(str("Not enough currency!"), Color(1, 0, 0, 1))
		
	return has_enough_currency
