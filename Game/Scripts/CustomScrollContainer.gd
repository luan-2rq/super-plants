extends Container
class_name CustomScrollContainer

export(bool) var vertical_scroll_enabled = true
export(bool) var horizontal_scroll_enabled = true

onready var control_node = $Control
onready var max_scroll : Vector2

export var v_scroll = 0
export var h_scroll = 0

export(bool) var follow_mode = false
export(Vector2) var follow_mode_offset = Vector2.ZERO

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
	connect("resized", self, "_on_resize")
	apply_scroll()
	
func _on_resize():
	self.max_scroll = $Control.rect_size - rect_size
	
func _input(event: InputEvent) -> void:
	if vertical_scroll_enabled or horizontal_scroll_enabled:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if is_mouse_over(self.rect_global_position, self.rect_size):
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
				if vertical_scroll_enabled:
					set_v_scroll(v_scroll + direction_vector.y)
				if horizontal_scroll_enabled:
					set_h_scroll(h_scroll + direction_vector.x)
				
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_WHEEL_UP and event.is_pressed():
					set_v_scroll(v_scroll - event.get_factor() * rect_size.y /8) 
				if event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed():
					set_v_scroll(v_scroll + event.get_factor() * rect_size.y /8) 
				if event.button_index == BUTTON_WHEEL_LEFT and event.is_pressed():
					set_h_scroll(h_scroll - event.get_factor() * rect_size.x /8)
				if event.button_index == BUTTON_WHEEL_RIGHT and event.is_pressed():
					set_h_scroll(h_scroll + + event.get_factor() * rect_size.x /8)
					
			if event is InputEventPanGesture:
				if is_mouse_over(self.rect_global_position, self.rect_size):
					if vertical_scroll_enabled:
						set_v_scroll(v_scroll + event.delta.y * 8)
					if horizontal_scroll_enabled:
						set_h_scroll(h_scroll + event.delta.x * 8)

func set_v_scroll(value):
	self.v_scroll = clamp(value, 0, max_scroll.y)
	apply_scroll()

func set_h_scroll(value):
	self.h_scroll = clamp(value, 0, max_scroll.x)
	apply_scroll()
	
func apply_scroll():
	control_node.set_deferred("rect_position", -Vector2(self.h_scroll, self.v_scroll))

func is_mouse_over(rect_global_position: Vector2, rect_size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(rect_global_position.x, rect_global_position.y, rect_size.x, rect_size.y)
	return rect.has_point(mouse_position)
					
