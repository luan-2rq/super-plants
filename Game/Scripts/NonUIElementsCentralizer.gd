extends Control
class_name NonUIElementsCentralizer

onready var viewport = get_viewport()
onready var children = $Control.get_children()
	
func _process(delta):
	pass
	children = $Control.get_children()
	for child in children:
		if !child.is_in_group("NotCentered"):
			if child is Control:
				child.rect_position.x = viewport.size.x / 2 - child.rect_size.x / 2
			else:
				if child.name != "Terrain":
					child.global_position.x = viewport.size.x / 2
