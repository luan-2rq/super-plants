extends Container
class_name CustomScrollContainer

@export var vertical_scroll_enabled: bool = true
@export var horizontal_scroll_enabled: bool = true

@onready var control_node = get_child(0)
@onready var max_scroll : Vector2 = clamp_to_zero(control_node.size - size)

@export var v_scroll = 0
@export var h_scroll = 0

@export var follow_mode: bool = false
@export var follow_mode_offset: Vector2 = Vector2.ZERO

var dragging = false
var last_drag_pos : Vector2

signal ScrollStarted
signal ScrollEnded

func set_vertical_scroll_enabled(value):
	if !value:
		vertical_scroll_enabled = value
		dragging = value
	else:
		vertical_scroll_enabled = value
		
func set_horizontal_scroll_enabled(value):
	if !value:
		horizontal_scroll_enabled = value
		dragging = value
	else:
		horizontal_scroll_enabled = value

func _ready() -> void:
	connect("resized", Callable(self, "_on_resize"))
	apply_scroll()
	
func _on_resize():
	self.max_scroll = clamp_to_zero(control_node.size - size)
	
func clamp_to_zero(vector : Vector2):
	var clamped_to_zero = Vector2()
	clamped_to_zero.x = clamp(vector.x, 0, INF)
	clamped_to_zero.y = clamp(vector.y, 0, INF)
	return clamped_to_zero
	
func _input(event: InputEvent) -> void:
	if vertical_scroll_enabled or horizontal_scroll_enabled:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if is_mouse_over(self.global_position, self.size):
					emit_signal("ScrollStarted")
					last_drag_pos = event.position
					dragging = true
			else:
				emit_signal("ScrollEnded")
				dragging = false
				
		if follow_mode:
			if event is InputEventMouseMotion:
				if dragging:
					if vertical_scroll_enabled:
						set_v_scroll(v_scroll + event.relative.y)
					if horizontal_scroll_enabled:
						set_h_scroll(h_scroll + event.relative.x)
		else:
			if dragging:
				var direction_vector = (last_drag_pos - event.position)
				last_drag_pos = event.position
				if abs(direction_vector.y) > abs(direction_vector.x):
					if vertical_scroll_enabled:
						set_v_scroll(v_scroll + direction_vector.y)
					else:
						if horizontal_scroll_enabled:
							set_h_scroll(h_scroll + direction_vector.x)
				else:		
					if horizontal_scroll_enabled:
						set_h_scroll(h_scroll + direction_vector.x)
					else:
						if vertical_scroll_enabled:
							set_v_scroll(v_scroll + direction_vector.y)
						
						
			if event is InputEventMouseButton:
				if is_mouse_over(self.global_position, self.size):
					if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
						set_v_scroll(v_scroll - event.get_factor() * size.y /8) 
					if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
						set_v_scroll(v_scroll + event.get_factor() * size.y /8) 
					if event.button_index == MOUSE_BUTTON_WHEEL_LEFT and event.is_pressed():
						set_h_scroll(h_scroll - event.get_factor() * size.x /8)
					if event.button_index == MOUSE_BUTTON_WHEEL_RIGHT and event.is_pressed():
						set_h_scroll(h_scroll + + event.get_factor() * size.x /8)
					
			if event is InputEventPanGesture:
				if is_mouse_over(self.global_position, self.size):
					if(!dragging):
						if abs(event.delta.y) > abs(event.delta.x):
							if vertical_scroll_enabled:
								set_v_scroll(v_scroll + event.delta.y* 8)
							else:
								if horizontal_scroll_enabled:
									set_h_scroll(h_scroll + event.delta.x* 8)
						else:		
							if horizontal_scroll_enabled:
								set_h_scroll(h_scroll + event.delta.x* 8)
							else:
								if vertical_scroll_enabled:
									set_v_scroll(v_scroll + event.delta.y* 8)

func set_v_scroll(value):
	self.v_scroll = clamp(value, 0, max_scroll.y)
	apply_scroll()

func set_h_scroll(value):
	self.h_scroll = clamp(value, 0, max_scroll.x)
	apply_scroll()
	
func apply_scroll():
	control_node.set_deferred("position", -Vector2(self.h_scroll, self.v_scroll))

func is_mouse_over(global_position: Vector2, size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(global_position.x, global_position.y, size.x, size.y)
	return rect.has_point(mouse_position)
					
