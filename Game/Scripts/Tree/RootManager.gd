extends NonUIElementsCentralizer
class_name RootManager

var offset = 300

func _ready():
	Events.connect("on_grow", self, "_set_focus")

func _set_focus(tree_type, focus_point):
	if tree_type == Enums.TreeType.Root:
		self.scroll_vertical = int(focus_point.y) - offset
