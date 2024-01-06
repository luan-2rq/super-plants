extends Spatial

func _process(delta):
	self.translation += Vector3.FORWARD * delta * -2
	if self.translation.z > 12.9:
		self.translation.z = -12.9
