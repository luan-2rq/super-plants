extends DraggableItem
class_name SmallTruckItem

var start_action = false

func start_action() -> void:
	start_action = true
	
func _proccess(delta):
	if start_action:
		pass
	else:
		pass
