extends DraggableItem
class_name InnerScannerItem

export(NodePath) var scanner_circle_path
export(NodePath) var arrow_path

onready var scanner_circle : Sprite = get_node(scanner_circle_path)
onready var arrow : Sprite = get_node(arrow_path)

#onready var area : Area2D = $Area2D

func _ready():
	var scanner_tex_size : Vector2 = scanner_circle.texture.get_size()
	scanner_circle.scale = Vector2(config.initial_range_radius*2, config.initial_range_radius*2) / scanner_tex_size
	
func start_action():
	if .start_action():
		arrow.visible = true
		var arrow_tex_size : Vector2 = arrow.texture.get_size()
		var closest_ground_element = ground_elements_manager.closest_ground_element(self.global_position)
		var distance = (closest_ground_element.global_position-self.global_position).length()
		var direction = (closest_ground_element.global_position-self.global_position).normalized()
		arrow.scale.x = config.arrow_max_size / arrow_tex_size.x
		if distance < arrow.scale.x * arrow_tex_size.x:
			arrow.scale.x = distance / arrow_tex_size.x
			closest_ground_element.reveal()
			var floating_text = floating_text_scene.instance()
			floating_text.z_index = 5
			floating_text.global_position = self.global_position
			get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
			floating_text.display_text("You got it right!", Color(0, 1, 0, 1), 0.5)
		arrow.rotation = atan2(direction.y, direction.x)
	else:
		queue_free()
