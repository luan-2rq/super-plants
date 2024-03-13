extends Node
class_name TrainWagon

var data : Resource
@export var fill_sprite_path : NodePath
@onready var fill_sprite = get_node(fill_sprite_path)

func _ready() -> void:
	fill_sprite.material = fill_sprite.material.duplicate()

func activate():
	self.modulate = Color(0,1,0,1)

func select():
	self.modulate = Color(1, 0, 0, 1)
	
func deselect():
	self.modulate = Color(1, 1, 1, 0.156)
	
func set_fill(percentage):
	fill_sprite.material.set_shader_parameter('fill_percentage', percentage)
