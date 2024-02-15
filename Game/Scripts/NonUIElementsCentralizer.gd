extends Control
class_name NonUIElementsCentralizer

onready var viewport = get_viewport()
onready var children = get_children()
	
func _ready():
	for child in children:
		if !child.is_in_group("NotCentered"):
			if child is Control:
				child.rect_position.x = rect_size.x / 2 - child.rect_size.x / 2
			else:
				if child.name != "Terrain":
					child.global_position.x = rect_size.x / 2
