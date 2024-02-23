extends Control
class_name ScrollController

export(NodePath) var plant_scroll_container_path
export(NodePath) var root_scroll_container_path

onready var plant_scroll_container =  get_node(plant_scroll_container_path)
onready var root_scroll_container = get_node(root_scroll_container_path)
onready var plant_scroll_container_control = plant_scroll_container.get_node("Control")
onready var root_scroll_container_control = root_scroll_container.get_node("Control")

var plant_scrolling : bool
var root_scrolling : bool

func _ready() -> void:
	#Set initial scroll
	var initial_scroll = plant_scroll_container_control.rect_size.y - plant_scroll_container.rect_size.y
	var horizontal_center = (plant_scroll_container_control.rect_size.x - plant_scroll_container.rect_size.x) / 2
	plant_scroll_container.connect("ScrollStarted", self, "_on_scroll_started", [plant_scroll_container])
	root_scroll_container.connect("ScrollStarted", self, "_on_scroll_started", [root_scroll_container])
	plant_scroll_container.connect("ScrollEnded", self, "_on_scroll_ended", [plant_scroll_container])
	root_scroll_container.connect("ScrollEnded", self, "_on_scroll_end", [root_scroll_container])
	Events.connect("disable_scroll", self, "_on_disable_scroll")
	Events.connect("enable_scroll", self, "_on_enable_scroll")
	Events.connect("disable_follow_mode", self, "_on_disable_follow_mode")
	Events.connect("enable_follow_mode", self, "_on_enable_follow_mode")
	
func _on_scroll_started(source):
	if source == plant_scroll_container:
		plant_scrolling = true
	else:
		root_scrolling = true
	
func _on_scroll_ended(source):
	if source == plant_scroll_container:
		plant_scrolling = false
	else:
		root_scrolling = false
	
func _process(delta: float) -> void:
	if plant_scrolling:
		root_scroll_container.set_h_scroll(plant_scroll_container.h_scroll)
	elif root_scrolling:
		plant_scroll_container.set_h_scroll(root_scroll_container.h_scroll)

func _on_disable_scroll():
	print("Disable Scroll")
	plant_scroll_container.set_vertical_scroll_enabled(false)
	root_scroll_container.set_vertical_scroll_enabled(false)
	plant_scroll_container.set_horizontal_scroll_enabled(false)
	root_scroll_container.set_horizontal_scroll_enabled(false)
	
func _on_enable_scroll():
	print("Enable Scroll")
	plant_scroll_container.set_vertical_scroll_enabled(true)
	root_scroll_container.set_vertical_scroll_enabled(true)
	plant_scroll_container.set_horizontal_scroll_enabled(true)
	root_scroll_container.set_horizontal_scroll_enabled(true)
	
func _on_enable_follow_mode():
	print("Enable Follow Mode")
	plant_scroll_container.follow_mode = true
	root_scroll_container.follow_mode = true

func _on_disable_follow_mode():
	print("Disable Follow Mode")
	plant_scroll_container.follow_mode = false
	root_scroll_container.follow_mode = false
