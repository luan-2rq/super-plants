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
	#deprecated
	#Events.connect("on_ground_element_reveal", self, "_on_ground_element_reveal")
	
func _process(delta: float) -> void:
	grow_branchs(delta*tree_structure_config.step_length)

func grow_branchs(amount_to_grow):
	var i = 0
	while i < branchs.size():
		var has_grown_completlely = branchs[i].instance.grow_directional(amount_to_grow)
		terrain.carve(branchs[i].instance.points[-1] + self.branchs[i].instance.global_position, 50)
		if has_grown_completlely:
			Events.emit_signal("root_full_grown", branchs[i])
			branchs.remove(i)
			i-=1
		i+=1
		
func generate_branch(to : Vector2, overlapping_ground_element : GroundElement = null, parent : BranchData = null):
	var branch
	if parent == null:
		var local_position = Vector2.ZERO
		branch = BranchData.new(null, 1, 1, 0, 0, tree_structure_config.bake_interval, 0, 0, to)
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		branch.overlapping_ground_element = overlapping_ground_element
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		branchs.append(branch)
		self.add_child(branch.instance)
	else:
		var local_position = parent.instance.points[-1]
		branch = BranchData.new(parent, 1, 1, 0, 0, tree_structure_config.bake_interval, 0, 0, to)
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		branch.overlapping_ground_element = overlapping_ground_element
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		branchs.append(branch)
		parent.instance.add_child(branch.instance)
	return branch

#Deprecated
#func _on_ground_element_reveal(to):
#	generate_branch(to)
