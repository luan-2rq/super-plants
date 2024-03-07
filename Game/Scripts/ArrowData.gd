extends Resource
class_name ArrowData

func init(global_pos : Vector2, distance : float, direction : Vector2):
	self.global_pos = global_pos
	self.distance = distance
	self.direction = direction

export var global_pos : Vector2
export var distance : float
export var direction : Vector2

