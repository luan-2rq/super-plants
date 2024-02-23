extends Node2D
class_name DirectionalTreeNode

#Config
export var tree_structure_config : Resource

var n_branchs : int = 1

onready var terrain = $"../Terrain"
var tree : BranchData
var branchs = Array()

var cur_max_point = Vector2.ZERO
var direction = Vector2(0, 1)

func _ready():
	pass

func grow_tree():
	for i in range(branchs.size()):
		branchs[i].instance.grow_directional(tree_structure_config.step_length, direction)
		terrain.carve(branchs[i].instance.points[-1] + self.branchs[i].instance.global_position, 50)
		
	if tree == null:
		tree = BranchData.new(null, 0, 0, 0, 0, tree_structure_config.bake_interval, 0)
		tree.instance = BranchLine.new(tree, tree_structure_config)
		tree.instance.width = 10
		tree.instance.z_index = 10
		tree.instance.grow_directional(tree_structure_config.step_length, direction)
		branchs.append(tree)
		add_child(tree.instance)
	else:
		var branch_diff = n_branchs - branchs.size()
		var new_branch
		if branch_diff > 0:
			var local_position = tree.instance.points[-1]
			new_branch = BranchData.new(tree, 1, 1, 0, 0, tree_structure_config.bake_interval, 0)
			new_branch.instance = BranchLine.new(new_branch, tree_structure_config)
			new_branch.instance.width = 2
			new_branch.instance.z_index = 10
			new_branch.instance.position = local_position
			branchs.append(new_branch)
			tree.instance.add_child(new_branch.instance)
			new_branch.instance.grow_directional(tree_structure_config.step_length, direction)

func _on_IncrementalButton_pressed():
	grow_tree()
	

