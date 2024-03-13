extends Node3D

var direction = Vector3.FORWARD
func _process(delta):
	self.position += direction * delta * -2
	if self.position.z > 12.9:
		self.direction = Vector3.BACK
		self.rotation_degrees.y = 180
		self.position.x = 0
		#self.translation.z = -12.9
	elif self.position.z < -12.9:
		self.direction = Vector3.FORWARD
		self.rotation_degrees.y = 0
		self.position.x = -2.8
