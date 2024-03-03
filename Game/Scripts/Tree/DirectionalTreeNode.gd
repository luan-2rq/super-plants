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

func _process(delta: float) -> void:
	grow_branchs(delta*tree_structure_config.step_length)

func grow_branchs(amount_to_grow):
	for i in range(branchs.size()):
		branchs[i].instance.grow_directional(amount_to_grow)
		terrain.carve(branchs[i].instance.points[-1] + self.branchs[i].instance.global_position, 50)

func generate_branch(to : Vector2, parent : BranchData = null):
	if parent == null:
		var local_position = Vector2.ZERO
		var branch = BranchData.new(null, 1, 1, 0, 0, tree_structure_config.bake_interval, 0, 0, to)
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		branchs.append(branch)
		self.add_child(branch.instance)
	else:
		var local_position = parent.instance.points[-1]
		var branch = BranchData.new(parent, 1, 1, 0, 0, tree_structure_config.bake_interval, 0, 0, to)
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		branchs.append(branch)
		parent.instance.add_child(branch.instance)
