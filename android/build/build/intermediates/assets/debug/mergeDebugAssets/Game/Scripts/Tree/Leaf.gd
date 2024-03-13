extends Sprite2D
class_name Leaf

var data

func _init(leaf_data):
	self.data = leaf_data

func _ready():
	self.rotation = data.rot
