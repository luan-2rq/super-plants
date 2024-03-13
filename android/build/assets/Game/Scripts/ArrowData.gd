extends Resource
class_name ArrowData

func init(global_pos : Vector2, distance : float, direction : Vector2):
	self.pos = global_pos
	self.distance = distance
	self.direction = direction

#position in the container
@export var pos : Vector2
@export var distance : float
@export var direction : Vector2

