extends DraggableItem
class_name InnerScannerItem

@export var scanner_circle_path: NodePath

@onready var scanner_circle : Sprite2D = get_node(scanner_circle_path)

#onready var area : Area2D = $Area2D

func _ready():
	var scanner_tex_size : Vector2 = scanner_circle.texture.get_size()
	scanner_circle.scale = Vector2(config.initial_range_radius*2, config.initial_range_radius*2) / scanner_tex_size
	
func start_action():
	if super.start_action():
		arrow_controller.add_arrow(self.global_position)
		queue_free()
	else:
		queue_free()
