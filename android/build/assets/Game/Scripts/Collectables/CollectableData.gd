extends Resource
class_name CollectableData

@export var pos : Vector2
@export var price : float

func init(pos : Vector2, price : float) -> void:
	self.pos = pos
	self.price = price
