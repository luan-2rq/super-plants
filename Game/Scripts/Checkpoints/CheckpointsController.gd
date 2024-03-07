extends NonUIElementsCentralizer

export(Resource) var checkpoint_configs
var checkpoints : Array
var checkpoints_data : CheckpointsData

onready var screen_size = OS.window_size

func _ready():
	checkpoints_data = SaveManager.get_specific_save(Enums.SaveName.checkpoints_data)
	if checkpoints_data == null:
		checkpoints_data = CheckpointsData.new()
		SaveManager.set_specific_save(Enums.SaveName.checkpoints_data, checkpoints_data)
		for checkpoint_config in checkpoint_configs.checkpoints:
			#checkpoint data
			var checkpoint_data = CheckpointData.new()
			checkpoints_data.checkpoints.append(checkpoint_data)
			add_checkpoint(checkpoint_data, checkpoint_config)
	else:
		for i in range(checkpoints_data.checkpoints.size()):
			add_checkpoint(checkpoints_data.checkpoints[i], checkpoint_configs.checkpoints[i])

func add_checkpoint(checkpoint_data : CheckpointData, checkpoint_config : CheckpointConfig):
	var checkpoint = Checkpoint.new(checkpoint_data, checkpoint_config, self.rect_size.y)
	checkpoint.rect_position = Vector2(0, self.rect_size.y - checkpoint_config.vertical_local_position)
	checkpoint.color = checkpoint_config.color
	checkpoint.rect_size = Vector2(screen_size.x * 2, checkpoint_configs.checkpoint_vertical_size)
	checkpoint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Events.connect("on_grow", checkpoint, "verify_checkpoint_achieved")
	add_child(checkpoint)
	if checkpoint_data.reached == true:
		checkpoint.visible = false
