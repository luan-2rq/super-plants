extends DraggableItem
class_name InnerScannerItem

export(NodePath) var scanner_circle_path
onready var scanner_circle : Sprite = get_node(scanner_circle_path)
export(NodePath) var arrow_path
onready var arrow : Sprite = get_node(arrow_path)

onready var area : Area2D = $Area2D

func _ready():
	var scanner_tex_size : Vector2 = scanner_circle.texture.get_size()
	scanner_circle.scale = Vector2(config.initial_range_radius*2, config.initial_range_radius*2) / scanner_tex_size
	
func start_action():
	arrow.visible = true
	var arrow_tex_size : Vector2 = arrow.texture.get_size()
	arrow.scale.x = config.arrow_max_size / arrow_tex_size.x
	var direction = ground_elements_manager.closest_ground_element_direction(self.global_position)
	arrow.rotation = atan2(direction.y, direction.x)
