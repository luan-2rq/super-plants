tool
class_name ExpandableCellsContainer
extends Container

var _cell_offset: int = 0

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var children = get_children()
		var children_count = children.size()
		
		if children_count > 0:
			var h_size = self.rect_size.x
			var closed_h_size_percentage
			var cell_h_size
			var cell_closed_h_size
			
			var cur_h_position = 0
			for i in range(children_count):
				fit_child_in_rect(children[i], Rect2(Vector2(), self.rect_size))
				if i == 0:
					cell_closed_h_size = _find_child_with_name(children[0], "ClosedContent").rect_size.x
					closed_h_size_percentage = cell_closed_h_size / children[0].rect_size.x
					cell_h_size = self.rect_size.x / (1 + (children_count-1) * closed_h_size_percentage)
					if children_count > 1:
						children[i].rect_size.x = cell_h_size
						children[i].rect_position.x = (children_count - 1) * closed_h_size_percentage * cell_h_size
					else:
						children[i].rect_size.x = h_size
						children[i].rect_position.x = 0
				else: 
					children[i].rect_size.x = cell_h_size
					children[i].rect_position.x = - (cell_h_size - closed_h_size_percentage * cell_h_size) + ((children_count - i - 1) * closed_h_size_percentage * cell_h_size)

func set_some_setting():
	queue_sort()

func set_cell_offset(value: int) -> void:
	_cell_offset = value
	
func _find_child_with_name(node, name_to_find):
	# Check if the current node has the name we're looking for
	if node.name == name_to_find:
		return node

	# Recursively search through the node's children
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		var result = _find_child_with_name(child, name_to_find)
		if result != null:
			return result

	# If not found, return null
	return null
