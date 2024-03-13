extends NonUIElementsCentralizer
class_name RootManager


@export var root_path: NodePath
@onready var root : DirectionalTreeNode = get_node(root_path)

@export var extremity: PackedScene

var temporary_line
var dragging_root : bool

var beginning_extremity : Area2D
var end_extremity : Area2D

func _ready():	
	temporary_line = Line2D.new()
	temporary_line.add_point(Vector2.ZERO)
	root.add_child(temporary_line)
	
	beginning_extremity = extremity.instantiate()
	beginning_extremity.z_index = 11
	root.add_child(beginning_extremity)
	
	end_extremity = extremity.instantiate()
	root.add_child(end_extremity)
	
func _process(delta):
	if dragging_root:
		temporary_line.remove_point(1)
		temporary_line.add_point(get_global_mouse_position() -  root.get_global_position())
		end_extremity.position = get_global_mouse_position() -  root.get_global_position()

func _input(event):
	if event is InputEventMouseButton:
		var area = get_tree().get_root().get_node("Main/UI/Popups")
		var overlapped_ground_element = null
		if event.pressed:
			if is_mouse_over(beginning_extremity.global_position, beginning_extremity.texture.get_size() * beginning_extremity.scale):
				dragging_root = true
				Events.emit_signal("enable_follow_mode")
				dragging_root = true
				if event.pressed:
					temporary_line.remove_point(1)
					temporary_line.add_point(get_global_mouse_position() - root.get_global_position())
		else:
			if dragging_root:
				if event.button_index == MOUSE_BUTTON_LEFT:
					dragging_root = false
					var line = temporary_line.duplicate()
					var end_extremity_duplicate = extremity.instantiate()
					end_extremity_duplicate.position = temporary_line.get_point_position(1)
					root.add_child(line)
					root.add_child(end_extremity_duplicate)
					temporary_line.remove_point(1)
					for ground_element in end_extremity.get_overlapping_areas():
						if ground_element is Groundwater:
							overlapped_ground_element = ground_element
							break
							
					var overlapped_ground_element_index = -1
					if overlapped_ground_element:
						overlapped_ground_element_index = overlapped_ground_element.data.index
					
					root.generate_branch(end_extremity_duplicate.global_position, overlapped_ground_element_index)
					Events.emit_signal("disable_follow_mode")

func is_mouse_over(global_position: Vector2, size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(global_position.x, global_position.y, size.x, size.y)
	return rect.has_point(mouse_position)
