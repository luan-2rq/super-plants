extends Control
class_name PlantManager

export(PackedScene) var extremity
var offset = 250

onready var plant : NormalTreeNode = $ScrollController/PlantScrollContainer/Control/Plant
onready var plant_scroll_container =  $ScrollController/PlantScrollContainer
onready var plant_scroll_container_control = $ScrollController/PlantScrollContainer/Control

onready var root : DirectionalTreeNode = $ScrollController/RootScrollContainer/Control/Root

#Pumping
var temporary_line
var screen_pressed

var beginning_extremity : Area2D
var end_extremity : Area2D

func _ready():	
	temporary_line = Line2D.new()
	temporary_line.add_point(Vector2.ZERO)
	root.add_child(temporary_line)
	
	beginning_extremity = extremity.instance()
	root.add_child(beginning_extremity)
	
	end_extremity = extremity.instance()
	root.add_child(end_extremity)

func _set_focus(tree_type, focus_point):
	if tree_type == Enums.TreeType.Plant:
		#print('Focus point: ' + str(control.rect_size.y - rect_size.y - int(focus_point.y)))
		plant_scroll_container.scroll_vertical = plant_scroll_container_control.rect_size.y - plant_scroll_container.rect_size.y - int(focus_point.y) + offset

#pumping controller: Maybe create another code?
func _input(event):
	if event is InputEventMouseButton:
		var area = get_tree().get_root().get_node("Main/UI/Popups")
		if event.pressed:
			if is_mouse_over(beginning_extremity.global_position, beginning_extremity.texture.get_size() * beginning_extremity.scale):
				Events.emit_signal("enable_follow_mode")
				screen_pressed = true
				if event.pressed:
					temporary_line.remove_point(1)
					temporary_line.add_point(get_global_mouse_position() - root.get_global_position())
		else:
			if event.button_index == BUTTON_LEFT:
				screen_pressed = false
				var line = temporary_line.duplicate()
				var end_extremity_duplicate = extremity.instance()
				end_extremity_duplicate.position = temporary_line.get_point_position(1)
				#self.direction = (get_global_mouse_position() - plant.get_global_position()).normalized()
				root.add_child(line)
				root.add_child(end_extremity_duplicate)
				temporary_line.remove_point(1)
				for ground_element in end_extremity.get_overlapping_areas():
					if ground_element is Groundwater:
						ground_element.pump(0.05)
				Events.emit_signal("disable_follow_mode")

func _process(delta):
	if screen_pressed:
		temporary_line.remove_point(1)
		temporary_line.add_point(get_global_mouse_position() -  root.get_global_position())
		end_extremity.position = get_global_mouse_position() -  root.get_global_position()

func is_mouse_over(rect_global_position: Vector2, rect_size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(rect_global_position.x, rect_global_position.y, rect_size.x, rect_size.y)
	return rect.has_point(mouse_position)
