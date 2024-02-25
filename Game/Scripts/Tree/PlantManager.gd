extends Control
class_name PlantManager

export(PackedScene) var extremity
export(NodePath) var plant_production_fill_path
export(Material) var plant_production_fill_material

var offset = 250
var production_yield_time = 1
var elapsed_time = 0

onready var plant_producion_fill = get_node(plant_production_fill_path)

onready var plant : NormalTreeNode = $ScrollController/PlantScrollContainer/Control/Plant
onready var plant_scroll_container =  $ScrollController/PlantScrollContainer
onready var plant_scroll_container_control = $ScrollController/PlantScrollContainer/Control

onready var root : DirectionalTreeNode = $ScrollController/RootScrollContainer/Control/Root

onready var grow_data = GrowData.new()

#Pumping
var temporary_line
var dragging_root : bool

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
	
	Events.connect("on_start_pump", self, "_on_water_pump_start")
	Events.connect("on_grow", self, "_on_plant_grow")
	
	plant_producion_fill.set_material(plant_production_fill_material.duplicate())

#To do: input this root logic from here
func _input(event):
	if event is InputEventMouseButton:
		var area = get_tree().get_root().get_node("Main/UI/Popups")
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
				if event.button_index == BUTTON_LEFT:
					dragging_root = false
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
	#To do: Remove this logic from here
	if dragging_root:
		temporary_line.remove_point(1)
		temporary_line.add_point(get_global_mouse_position() -  root.get_global_position())
		end_extremity.position = get_global_mouse_position() -  root.get_global_position()
	
	if grow_data.height_to_grow > grow_data.height:
		plant.grow_tree()
	
	elapsed_time += delta
	if production_yield_time < elapsed_time:
		plant_producion_fill.material.set_shader_param("fill_percentage", plant_producion_fill.material.get_shader_param("fill_percentage") + 0.05)
		elapsed_time = 0

func is_mouse_over(rect_global_position: Vector2, rect_size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(rect_global_position.x, rect_global_position.y, rect_size.x, rect_size.y)
	return rect.has_point(mouse_position)

func _on_water_pump_start(groundwater_size):
	grow_data.height_to_grow += groundwater_size

func _on_plant_grow(tree_type, max_point):
	grow_data.height = max_point.y
