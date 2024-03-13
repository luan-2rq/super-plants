extends Button
class_name ExpandableCell

var _expanded_content : Control
var _closed_content : Control

func _ready():
	_expanded_content = $HBoxContainer/ExpandedContent
	_closed_content = $HBoxContainer/ClosedContent

func expand(offset: int):
	#var initial_h_position = self.rect_position.x
	var target_h_position = self.position.x + _expanded_content.size.x
	self.position.x = target_h_position
	#while self.rect_position.x < target_h_position:
		#self.rect_position.x = lerp(initial_h_position, target_h_position, 0.5)
		#yield(get_tree(), "idle_frame")
	
func shrink(offset: int):
	#var initial_h_position = self.rect_position.x
	var target_h_position = self.position.x - _expanded_content.size.x
	self.position.x = target_h_position
	#while self.rect_position.x > target_h_position:
		#self.rect_position.x = lerp(initial_h_position, target_h_position, 0.5)
		#yield(get_tree(), "idle_frame")
