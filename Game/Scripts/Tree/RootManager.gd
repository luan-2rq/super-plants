extends ScrollContainer
class_name RootManager

func _ready():
	Events.connect("on_grow", self, "_set_focus")

func _set_focus(focus_point):
	self.scroll_vertical = int(focus_point.y) - 450
