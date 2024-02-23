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
		if control_vertical_rect_size - max_point.y < rect_position.y + rect_size.y:
			visible = false
