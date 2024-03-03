extends DraggableItem
class_name TrainWagonItem

export(NodePath) var scanner_circle_path

onready var scanner_circle : Sprite = get_node(scanner_circle_path)
var cur_train_wagon

#onready var area : Area2D = $Area2D

func _ready():
	var scanner_tex_size : Vector2 = scanner_circle.texture.get_size()
	scanner_circle.scale = Vector2(config.select_circle_radius*2, config.select_circle_radius*2) / scanner_tex_size

func _process(delta):
	if cur_train_wagon:
		train.deselect_wagon(cur_train_wagon)
	cur_train_wagon = train.get_aimed_wagon(self.global_position.x)
	if cur_train_wagon:
		train.select_wagon(cur_train_wagon)
	
func start_action():
	if .start_action():
		if cur_train_wagon:
			train.activate_wagon(cur_train_wagon)
		queue_free()
	else:
		if cur_train_wagon:
			train.deselect_wagon(cur_train_wagon)
		queue_free()
