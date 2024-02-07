extends ColorRect
class_name Checkpoint

var checkpoint_data : CheckpointData
var checkpoint_config : CheckpointConfig
var control_vertical_rect_size : float

func _init(checkpoin_data : CheckpointData, checkpoint_config : CheckpointConfig, control_vertical_rect_size : float):
	self.checkpoint_data = checkpoint_data
	self.checkpoint_config = checkpoint_config
	self.control_vertical_rect_size = control_vertical_rect_size

func _ready():
	pass

func _verify_checkpoint_achieved(tree_type, max_point):
	if tree_type == checkpoint_config.tree_type:
		if max_point.y > control_vertical_rect_size - rect_position.y:
			visible = false
