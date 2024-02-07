extends Spatial

var direction = Vector3.FORWARD
func _process(delta):
	self.translation += direction * delta * -2
	if self.translation.z > 12.9:
		self.direction = Vector3.BACK
		self.rotation_degrees.y = 180
		self.translation.x = 0
		#self.translation.z = -12.9
	elif self.translation.z < -12.9:
		self.direction = Vector3.FORWARD
		self.rotation_degrees.y = 0
		self.translation.x = -2.8
