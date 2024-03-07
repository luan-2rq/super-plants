extends Node2D
class_name DirectionalTreeNode

#Config
export var tree_structure_config : Resource

var n_branchs : int = 1

onready var terrain = $"../Terrain"
var tree : BranchData
#var branchs = Array()

var cur_max_point = Vector2.ZERO
var direction = Vector2(0, 1)

var root_data : Resource

func _ready():
	root_data = SaveManager.get_specific_save(Enums.SaveName.root_data)
	if root_data == null:
		print("root_data null")
		root_data = RootData.new()
		SaveManager.set_specific_save(Enums.SaveName.root_data, root_data)
	else:
		init_from_save()
	
func _process(delta: float) -> void:
	#To do: remove hardcoded growth velocity
	grow_branchs(delta*100)

func grow_branchs(amount_to_grow):
	var i = 0
	while i < root_data.branchs.size():
		var has_grown_completlely = root_data.branchs[i].instance.grow_directional(amount_to_grow)
		terrain.carve(root_data.branchs[i].instance.points[-1] + root_data.branchs[i].instance.global_position, 50)
		if has_grown_completlely and !root_data.branchs[i].has_grown_completely:
			Events.emit_signal("root_full_grown", root_data.branchs[i])
			root_data.branchs[i].has_grown_completely = true
		i+=1
		
func generate_branch(to : Vector2, overlapping_ground_element_index : int = -1, parent : BranchData = null):
	var branch
	if parent == null:
		var local_position = Vector2.ZERO
		branch = BranchData.new()#BranchData.new(null, 1, 1, 0, 0, to)
		branch.parent = null
		branch.depth = 1
		branch.position_in_parent = 1
		branch.leaf_count = 0
		branch.collectable_holder_count = 0
		branch.to = to
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		branch.overlapping_ground_element_index = overlapping_ground_element_index
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		root_data.branchs.append(branch)
		self.add_child(branch.instance)
	else:
		var local_position = parent.instance.points[-1]
		branch = BranchData.new()#BranchData.new(parent, 1, 1, 0, 0, to)
		branch.parent = parent
		branch.depth = 1
		branch.position_in_parent = 1
		branch.leaf_count = 0
		branch.collectable_holder_count = 0
		branch.to = to
		branch.instance = BranchLine.new(branch, tree_structure_config)
		branch.instance.width = 15
		branch.instance.z_index = 10
		branch.instance.position = local_position
		branch.overlapping_ground_element_index = overlapping_ground_element_index
		
		var width_curve = Curve.new()
		width_curve.add_point(Vector2(0, 1))
		width_curve.add_point(Vector2(3, 0.2))
		#branch.instance.width_curve = width_curve
		
		root_data.branchs.append(branch)
		parent.instance.add_child(branch.instance)
	return branch

func init_from_save():
	for branch in root_data.branchs:
		if branch.parent == null:
			branch.instance = BranchLine.new(branch, tree_structure_config)
			branch.instance.width = 15
			branch.instance.z_index = 10
			branch.instance.position = Vector2.ZERO
			self.add_child(branch.instance)
		else:
			pass
			#To do: logic when there is a parent

#Deprecated
#func _on_ground_element_reveal(to):
#	generate_branch(to)
