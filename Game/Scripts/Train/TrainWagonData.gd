extends Resource
class_name TrainWagonData

export var index : int
export var active : bool = false
export var payload : float

func init(index, active):
	self.index = index
	self.active = active
