extends ColorRect
class_name Checkpoint

var data : CheckpointData
var config : CheckpointConfig
var control_vertical_rect_size : float

func _init(checkpoint_data : CheckpointData, checkpoint_config : CheckpointConfig, control_vertical_rect_size : float):
	self.data = checkpoint_data
	self.config = checkpoint_config
	self.control_vertical_rect_size = control_vertical_rect_size

func _ready():
	pass

func verify_checkpoint_achieved(tree_type, max_point):
	if tree_type == config.tree_type:
		if control_vertical_rect_size - max_point.y < rect_position.y + rect_size.y:
			visible = false
			data.reached = true
