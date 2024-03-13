extends HBoxContainer
class_name DraggableButtonController

@export var draggable_buttons_config: Resource
@export var bottom_scroll_container_control_path: NodePath
@export var top_scroll_container_control_path: NodePath
@onready var bottom_scroll_container_control = get_node(bottom_scroll_container_control_path)
@onready var top_scroll_container_control = get_node(top_scroll_container_control_path)

#Internal
@export var terrain_path: NodePath
@export var ground_elements_manager_path: NodePath
@export var train_path: NodePath
@export var arrow_controller_path: NodePath
@onready var terrain = get_node(terrain_path)
@onready var ground_elements_manager = get_node(ground_elements_manager_path)
@onready var train = get_node(train_path)
@onready var arrow_controller = get_node(arrow_controller_path)

var buttons : Array

var cur_pressed_button : DraggableButton
var cur_game_item : DraggableItem
var dragging : bool = false

var referential_line : Line2D

func _ready() -> void:
	referential_line = Line2D.new()
	referential_line.add_to_group("NotCentered")
	bottom_scroll_container_control.add_child(referential_line)
	
	_instantiate_buttons()

func _instantiate_buttons():	
	for draggable_button_config in draggable_buttons_config.draggable_buttons_config:
		var button_instance = draggable_button_config.button_scene.instantiate()
		button_instance.config = draggable_button_config
		add_child(button_instance)
		buttons.append(button_instance)
		button_instance.connect("clicked", Callable(self, "_on_draggable_button_toggled").bind(button_instance))

func _on_draggable_button_toggled(pressed_button):
	Events.emit_signal("disable_scroll")
	self.cur_pressed_button = pressed_button

func _process(delta: float) -> void:
	if cur_pressed_button:
		if cur_pressed_button.pressed:
			if !is_mouse_over(cur_pressed_button.global_position, cur_pressed_button.size):	
				if dragging == false:
					dragging = true
					cur_game_item = cur_pressed_button.config.item_scene.instantiate()
					cur_game_item.terrain = terrain
					cur_game_item.ground_elements_manager = ground_elements_manager
					cur_game_item.train = train
					cur_game_item.arrow_controller = arrow_controller
					cur_game_item.config = cur_pressed_button.config
					if cur_pressed_button.config.draggable_type == Enums.DraggableType.Internal:
						bottom_scroll_container_control.add_child(cur_game_item)
					else:
						top_scroll_container_control.add_child(cur_game_item)
					cur_game_item.add_to_group("NotCentered")
				drag_action()	
		else:
			#Drop item
			Events.emit_signal("enable_scroll")
			dragging = false
			referential_line.clear_points()
			
			cur_game_item.start_action()
			
			cur_pressed_button = null

func drag_action():
	#Referential Line
	referential_line.clear_points()
	referential_line.position = Vector2(get_global_mouse_position().x - bottom_scroll_container_control.global_position.x, 0)
	var bottom_point : Vector2 = Vector2(0, get_global_mouse_position().y - bottom_scroll_container_control.global_position.y)
	referential_line.add_point(Vector2.ZERO)
	referential_line.add_point(bottom_point)
	
	#Game Item
	if cur_pressed_button.config.draggable_type == Enums.DraggableType.Internal:
		cur_game_item.global_position = get_global_mouse_position()
	else:
		cur_game_item.global_position = Vector2(get_global_mouse_position().x, top_scroll_container_control.global_position.y + top_scroll_container_control.size.y - 50)

func is_mouse_over(global_position: Vector2, size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(global_position.x, global_position.y, size.x, size.y)
	return rect.has_point(mouse_position)
