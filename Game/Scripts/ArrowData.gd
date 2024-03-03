extends Resource
class_name ArrowData

func _init(global_pos : Vector2, distance : float, direction : Vector2):
	self.global_pos = global_pos
	self.distance = distance
	self.direction = direction

var global_pos : Vector2
var distance : float
var direction : Vector2

