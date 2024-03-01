extends DraggableItem
class_name TruckItem

export(Material) var fill_material
export(NodePath) var fill_sprite_path

onready	var fill_sprite : Sprite = get_node(fill_sprite_path)
onready var safe_distance = get_viewport_rect().size * 1.1
onready var offset = 40

var moving : bool
var velocity = 30

func _ready() -> void:
	fill_sprite.set_material(fill_material.duplicate())

func start_action(): 
	if .start_action():
		moving = true
	else:
		self.queue_free()

func _process(delta: float) -> void:		
	if moving:
		self.global_position.x += delta * velocity
		if self.global_position.x >= safe_distance.x + offset:
			self.global_position.x = -offset
