extends Sprite
class_name Leaf

var position_on_branch : float
var default_scale : Vector2

func _init(position_on_branch : float, default_scale : Vector2):
	self.position_on_branch = position_on_branch
	self.default_scale = default_scale
	scale = default_scale
