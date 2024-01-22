extends NonUIElementsCentralizer
class_name PlantManager

var offset = 250
onready var control = $Control

func _ready():
	var initial_scroll = control.rect_size.y - rect_size.y
	set_deferred('scroll_vertical', initial_scroll)
	Events.connect("on_grow", self, "_set_focus")

func _set_focus(tree_type, focus_point):
	if tree_type == Enums.TreeType.Plant:
		#print('Focus point: ' + str(control.rect_size.y - rect_size.y - int(focus_point.y)))
		self.scroll_vertical = control.rect_size.y - rect_size.y - int(focus_point.y) + offset
