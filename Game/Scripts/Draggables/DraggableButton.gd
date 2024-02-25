extends Control
class_name DraggableButton

export(NodePath) var quantity_label_path
export(NodePath) var price_label_path

onready var quantity_label = get_node(quantity_label_path)
onready var price_label = get_node(price_label_path)

var config
signal clicked
var pressed = false
	
func _ready() -> void:
	price_label.bbcode_text = "[center]"+str(config.price)+"[/center]"
	#quantity_label.bbcode = "[center]"+str(config.price)+"[/center]"
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if is_mouse_over(rect_global_position, rect_size):
				emit_signal("clicked")
				pressed = true
		elif !event.is_pressed() and pressed:
			pressed = false

func is_mouse_over(rect_global_position: Vector2, rect_size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(rect_global_position.x, rect_global_position.y, rect_size.x, rect_size.y)
	return rect.has_point(mouse_position)
