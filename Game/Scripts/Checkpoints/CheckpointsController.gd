extends Control

export(Resource) var checkpoint_configs
var checkpoints : Array
onready var screen_size = OS.window_size

func _ready():
	for checkpoint_config in checkpoint_configs.checkpoints:
		add_checkpoint(CheckpointData.new(false), checkpoint_config)


func add_checkpoint(checkpoint_data : CheckpointData, checkpoint_config : CheckpointConfig):
	var checkpoint = Checkpoint.new(checkpoint_data, checkpoint_config)
	checkpoint.rect_position = Vector2(0, checkpoint_config.position)
	checkpoint.color = checkpoint_config.color
	checkpoint.rect_size = Vector2(screen_size.x, checkpoint_configs.checkpoint_size)
	checkpoint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Events.connect("on_grow", checkpoint, "_verify_checkpoint_achieved")
	add_child(checkpoint)