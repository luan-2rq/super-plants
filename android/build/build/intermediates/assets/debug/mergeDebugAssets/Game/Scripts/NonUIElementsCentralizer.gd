extends Control
class_name NonUIElementsCentralizer

@onready var viewport = get_viewport()
@onready var children = get_children()

func _ready() -> void:
	get_viewport().connect("size_changed", Callable(self, "_on_screen_resize"))
	
func _on_screen_resize():
	for child in children:
		if !child.is_in_group("NotCentered"):
			if child is Control:
				child.position.x = get_parent().size.x / 2 - child.size.x / 2
			else:
				if child.name != "Terrain":
					child.global_position.x = get_parent().size.x / 2
