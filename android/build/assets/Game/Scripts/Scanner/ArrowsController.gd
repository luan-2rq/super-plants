extends Node
class_name ArrowsController

@export var arrows_config : Resource
@export var ground_elements_manager_path: NodePath
@export var floating_text_scene: PackedScene

@onready var ground_elements_manager = get_node(ground_elements_manager_path)

func initialize() -> void:
	for ground_element in ground_elements_manager.ground_elements:
		if !ground_element.data.revealed:
			for arrow_data in ground_element.data.arrows:
				var arrow = instantiate_arrow(arrow_data)
				ground_element.arrows.append(arrow)

func instantiate_arrow(arrow_data):
	var arrow = arrows_config.arrow_prefab.instantiate()
	var arrow_tex_size : Vector2 = arrow.texture.get_size()
	var arrow_scale_x = arrows_config.arrow_max_size / arrow_tex_size.x
	arrow.scale = Vector2(arrow_scale_x, arrow_scale_x/4)
	arrow.rotation = atan2(arrow_data.direction.y, arrow_data.direction.x)
	if arrow_data.distance < arrow.scale.x * arrow_tex_size.x:
		arrow.scale.x = arrow_data.distance / arrow_tex_size.x
	self.add_child(arrow)
	arrow.global_position = arrow_data.pos
	return arrow

func add_arrow(global_pos):
	if ground_elements_manager.available_ground_elements.size() > 0:
		var arrow = arrows_config.arrow_prefab.instantiate()
		var arrow_tex_size : Vector2 = arrow.texture.get_size()
		var arrow_scale_x = arrows_config.arrow_max_size / arrow_tex_size.x
		arrow.scale = Vector2(arrow_scale_x, arrow_scale_x/4)
		
		var closest_ground_element = ground_elements_manager.closest_ground_element(global_pos)
		var distance = (closest_ground_element.global_position-global_pos).length()
		var direction = (closest_ground_element.global_position-global_pos).normalized()
		
		arrow.rotation = atan2(direction.y, direction.x)
		
		var arrow_data = ArrowData.new()
		arrow_data.init(global_pos - get_parent().global_position, distance, direction)
		
		closest_ground_element.add_arrow(arrow, arrow_data)
		
		arrow.global_position = global_pos - get_parent().global_position
		self.add_child(arrow)
		
		#Reveal groundelement in case it was placed above ground element
		if distance < arrow.scale.x * arrow_tex_size.x:
			arrow.scale.x = distance / arrow_tex_size.x
			ground_elements_manager.reveal_ground_element(closest_ground_element)
			#Events.emit_signal("on_ground_element_reveal", closest_ground_element.global_position)
			
			#Reveal floating text
			var floating_text = floating_text_scene.instantiate()
			floating_text.z_index = 5
			floating_text.global_position = global_pos
			get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
			floating_text.display_text("You got it right!", Color(0, 1, 0, 1), 0.5)
			return true
		else:
			return false
