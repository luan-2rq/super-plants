extends DraggableItem
class_name SmallTruckItem

export(Material) var fill_material
export(NodePath) var fill_sprite_path
onready	var fill_sprite : Sprite = get_node(fill_sprite_path)

func _ready() -> void:
	fill_sprite.set_material(fill_material.duplicate())

func start_action() -> void:
	pass
