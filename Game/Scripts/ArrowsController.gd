extends Node
class_name ArrowsController

export var arrows_config : Resource
export(NodePath) var ground_elements_manager_path
export(PackedScene) var floating_text_scene

onready var ground_elements_manager = get_node(ground_elements_manager_path)

func add_arrow(scanner) -> void:
	var arrow = arrows_config.arrow_prefab.instance()
	var arrow_tex_size : Vector2 = arrow.texture.get_size()
	var arrow_scale_x = arrows_config.arrow_max_size / arrow_tex_size.x
	arrow.scale = Vector2(arrow_scale_x, arrow_scale_x/4)
	
	var scanner_global_pos = scanner.global_position
	
	var closest_ground_element = ground_elements_manager.closest_ground_element(scanner_global_pos)
	var distance = (closest_ground_element.global_position-scanner_global_pos).length()
	var direction = (closest_ground_element.global_position-scanner_global_pos).normalized()
	
	arrow.rotation = atan2(direction.y, direction.x)
	
	var arrow_data = ArrowData.new(scanner_global_pos, distance, direction)
	closest_ground_element.add_arrow(scanner, arrow_data)
	
	scanner.get_parent().remove_child(scanner)
	scanner.add_child(arrow)
	self.add_child(scanner)
	
	#Reveal groundelement in case it was placed above ground element
	if distance < arrow.scale.x * arrow_tex_size.x:
		arrow.scale.x = distance / arrow_tex_size.x
		ground_elements_manager.reveal_ground_element(closest_ground_element)
		#Events.emit_signal("on_ground_element_reveal", closest_ground_element.global_position)
		
		#Reveal floating text
		var floating_text = floating_text_scene.instance()
		floating_text.z_index = 5
		floating_text.global_position = scanner_global_pos
		get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
		floating_text.display_text("You got it right!", Color(0, 1, 0, 1), 0.5)
