extends ColorRect
class_name Checkpoint

var checkpoint_data : CheckpointData
var checkpoint_config : CheckpointConfig

func _init(checkpoin_data : CheckpointData, checkpoint_config : CheckpointConfig):
	self.checkpoint_data = checkpoint_data
	self.checkpoint_config = checkpoint_config
	
func _ready():
	pass
	
func _verify_checkpoint_achieved(max_point):
	if max_point.y > get_global_position().y:
		queue_free()
