extends ColorRect
class_name Checkpoint

var checkpoint_data : CheckpointData
var checkpoint_config : CheckpointConfig

func _init(checkpoin_data : CheckpointData, checkpoint_config : CheckpointConfig):
	self.checkpoint_data = checkpoint_data
	self.checkpoint_config = checkpoint_config
	
func _ready():
	pass
	
func _verify_checkpoint_achieved(tree_type, max_point):
	if tree_type == checkpoint_config.tree_type:
		if max_point.y > rect_position.y:
			visible = false
