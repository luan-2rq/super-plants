extends Resource
class_name LeafData

export var pos_on_branch : float
export var rot : float

func init(pos_on_branch : float, rot: float) -> void:
	self.pos_on_branch = pos_on_branch
	self.rot = rot
