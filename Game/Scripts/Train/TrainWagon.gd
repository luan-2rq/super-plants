extends Node
class_name TrainWagon

func activate():
	self.modulate = Color(0,1,0,1)

func select():
	self.modulate = Color(1, 0, 0, 1)
	
func deselect():
	self.modulate = Color(1, 1, 1, 0.156)
