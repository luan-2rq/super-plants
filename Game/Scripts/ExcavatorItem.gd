extends DraggableItem
class_name TerrestrialScanner

onready var area : Area2D = $Area2D
onready var collision_shape : CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	collision_shape.shape.extents = config.scanning_range
	collision_shape.position.y = config.scanning_range.y

func start_action():
	terrain.carve(self.global_position, 100)
