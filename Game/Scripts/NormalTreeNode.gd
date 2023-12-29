#General purpose tree structure, serves for both root and trees
class_name NormalTreeNode
extends Node2D

#To do: separar em visual settings e other settings

export var __ = 'Tree Settings'
export var max_depth : int = 8
export(float, -3.14, 3.14) var angle_range : float = 0.7
export var stem_color : Color

export var ___ = 'Branches'
export var initial_branch_length : int = 20
export var max_branch_length : float = 12
export var initial_branch_count : int = 4
export var max_branch_count : int = 3
export var initial_branch_direction = Vector2(0, 1)

export var ____ = 'Leaves'
export var leaf_count : int
export(Texture) var leaf_texture : Texture
export var leaf_color : Color

export var _____ = 'Points Settings'
export var points_per_unit : float = 2
onready var initial_point_step : float = initial_branch_length / points_per_unit
onready var point_step : float = max_branch_length / points_per_unit
onready var point_count : int = max_branch_length * points_per_unit

export var ______ = 'Growth Settings'
export var growth : float = 1
export var growth_rate = 0.01

export var bounds : Resource

var tree : Branch 

func _ready():
	print_debug(self.global_position)
	tree = generate_tree()
	print_debug('Tree pos: ' + str(tree.pos))
	render_tree(tree)
	grow()
	
func render_tree(initial_branch : Branch):
	var cur_branch
	
	var branch_stack = Array()
	branch_stack.append(initial_branch)
	
	#Iterate through the branchs
	while branch_stack.size() > 0:
		cur_branch = branch_stack.pop_back()
		if cur_branch.depth == 0:
			cur_branch.line = BranchLine.new(cur_branch.points, 0, leaf_texture, leaf_color)
		else:
			cur_branch.line = BranchLine.new(cur_branch.points, leaf_count, leaf_texture, leaf_color)
			
		if cur_branch.parent == null:
			cur_branch.line.width = 5
			cur_branch.line.default_color = stem_color
			add_child(cur_branch.line)
		else:
			var position_point_index = int((cur_branch.parent.line.points.size() - 1) * cur_branch.position_in_parent)
			cur_branch.line.position = cur_branch.parent.line.points[position_point_index]
			cur_branch.line.width = 2
			cur_branch.parent.line.add_child(cur_branch.line)
		
		branch_stack += cur_branch.children
	
#FUNCTIONS TO GENERATE TREE

func generate_tree() -> Branch:
	var initial_branch = Branch.new(null, 0, 0, self.global_position)
	var cur_points : PoolVector2Array
	var cur_branch : Branch
	
	initial_branch.generate(initial_branch_length, points_per_unit, initial_point_step, angle_range, initial_branch_direction, bounds)
	
	var depth = 1
	var last_branches = Array()
	var cur_branches = Array()
	var cur_branch_position
	#Loop usado para cada level da root
	while depth < max_depth:
		if depth == 1:
			#Loop usado para cada branch
			for i in range(initial_branch_count):
				#Lógica para adicionar os primeiros branchs
				var position_in_parent = Random.range_float(0, 1)
				cur_branch_position = initial_branch.pos + initial_branch.points[int((initial_branch.points.size()-1) * position_in_parent)]
				cur_branch = Branch.new(initial_branch, position_in_parent, depth, cur_branch_position)
				cur_branch.generate(max_branch_length, points_per_unit, initial_point_step, angle_range, initial_branch_direction, bounds)
				
				initial_branch.add_branch_child(cur_branch)
				last_branches.append(cur_branch)
				cur_branches.append(cur_branch)
		else:
			#Loop de criação de Branchs
			for i in range(last_branches.size()):
				#Lógica para adicionar Branchs. Cada branch pode ter de 0 a 4 outros branchs.
				var cur_branch_children_count = Random.range_int(0, max_branch_count) 
				#Loop  usado para cada Branch
				for j in range(cur_branch_children_count):
					var position_in_parent = Random.range_float(0, 1)
					cur_branch_position = last_branches[i].pos + last_branches[i].points[int((last_branches[i].points.size()-1) * position_in_parent)]
					cur_branch = Branch.new(last_branches[i], position_in_parent, depth, cur_branch_position)
					cur_branch.generate(max_branch_length, points_per_unit, initial_point_step, angle_range, initial_branch_direction, bounds)
					
					last_branches[i].add_branch_child(cur_branch)
					cur_branches.append(cur_branch)
					
		last_branches = cur_branches
		cur_branches = Array()
		depth += 1
	
	var branch_stack = Array()
	branch_stack.append(initial_branch)
	
	return initial_branch
	
#FUNCTIONS FOR GROWTH

func grow():
	var branch_stack = Array()
	branch_stack.append(tree)
	
	var global_growth = growth * max_depth
	while branch_stack.size() > 0:
		var cur_branch = branch_stack.pop_back()
		if cur_branch.parent != null:
			var fill_percentage = clamp(cur_branch.parent.line.rest + cur_branch.parent.line.fill_percentage - cur_branch.position_in_parent, 0, 1)
			#var fill_percentage = clamp(cur_branch.parent.line.rest, 0, 1)
			cur_branch.line.rest = cur_branch.parent.line.rest - fill_percentage
			cur_branch.line.set_growth(fill_percentage)
		else:
			var fill_percentage = clamp(global_growth, 0, 1)
			cur_branch.line.rest = global_growth - fill_percentage
			cur_branch.line.set_growth(fill_percentage)
		branch_stack += cur_branch.children

func apply_growth(growth_diff):
	growth += growth_diff
	grow()

func _on_Button_pressed():
	apply_growth(growth_rate)
