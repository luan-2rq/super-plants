extends Control
class_name ExpandableCellsController

var _expandable_cells: Array = []
var _expandable_cells_container: ExpandableCellsContainer
var _current_opened_cell : int = 0
var _offset
	
func initialize(cell_offset: int, cell: PackedScene, n_of_cells: int) -> void:
	_expandable_cells_container = _find_child_with_name(self, "ExpandableCellsContainer")
	_expandable_cells_container.set_cell_offset(cell_offset)
	_offset = cell_offset
	for i in range(n_of_cells):
		_expandable_cells.append(cell.instance())
		_expandable_cells_container.add_child(_expandable_cells[i])
		_expandable_cells[i].connect("pressed", self, "_on_upgrade_cell_clicked", [i])

func _on_upgrade_cell_clicked(clicked_cell_index) -> void:
	if (clicked_cell_index != self._current_opened_cell):
		_open_upgrade_cell(clicked_cell_index)
		self._current_opened_cell = clicked_cell_index
	else:
		_close_upgrade_cell(clicked_cell_index)
		self._current_opened_cell = 0

func _close_upgrade_cell(cell_index: int):
	for i in range(_current_opened_cell, 0, -1):
		_expandable_cells[i].shrink(_offset)
	
func _open_upgrade_cell(cell_index: int):
	if cell_index > _current_opened_cell:
		for i in range(_current_opened_cell + 1, cell_index+1):
			_expandable_cells[i].expand(_offset)
	else:
		for i in range(_current_opened_cell, cell_index, -1):
			_expandable_cells[i].shrink(_offset)

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
