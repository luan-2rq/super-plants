#General purpose tree structure, serves for both root and trees
class_name NormalTreeNode
extends Node2D

#Config
@export var tree_structure_config : Resource
@export var collectables_controller_path: NodePath
@onready var collectables_controller = get_node(collectables_controller_path)

#Data
var tree : Resource
var cur_depth = 0

var cur_max_point = Vector2.ZERO

var grow_step = 10
var branch_count = 0
var elapsed_time = 0

var plant_data : PlantData

func _ready():
	plant_data = SaveManager.get_specific_save(Enums.SaveName.plant_data)
	if plant_data == null or (plant_data != null and (plant_data.active_branchs.size() == 0 and plant_data.branchs_to_be_spawned.size() == 0)):
		plant_data = PlantData.new()
		SaveManager.set_specific_save(Enums.SaveName.plant_data, plant_data)
	else:
		init_from_save()

#FUNÇÃO INCREMENTAL PARA CRESCER A ÁRVORE: -> Sem Retorno
# 1: Gera o primeiro branch
# 2: Aplica crescimento nos branchs ativos
# 3: Spawna os branchs filhos, quando for o caso
func grow_tree(grow_amount : float):
	var cur_branch
	if cur_depth <= tree_structure_config.max_depth:
		#1: Gera primeiro branch e coloca os filhos na filha de spawn
		if tree == null:
			tree = BranchData.new()#BranchData.new(null, cur_depth, 0, 0, 0)
			tree.parent = null
			tree.depth = cur_depth
			tree.position_in_parent = 0
			tree.leaf_count = 0
			tree.collectable_holder_count = 0
			
			tree.instance = BranchLine.new(tree, tree_structure_config, collectables_controller)
			tree.instance.width = 5
			tree.global_pos = self.global_position
			plant_data.active_branchs.append(tree)
			add_child(tree.instance)
			
			tree.instance.grow(grow_amount)
			cur_depth += 1
			branch_count += 1
			for i in range(tree_structure_config.initial_branch_count):
				var position_in_parent = Random.range_float(0, 1)
				cur_branch = BranchData.new()#BranchData.new(tree, cur_depth, position_in_parent, Random.range_int(0,  tree_structure_config.max_leaf_count), Random.range_int(0,  tree_structure_config.max_collectable_holder_count))
				cur_branch.parent = tree
				cur_branch.depth = cur_depth
				cur_branch.position_in_parent = position_in_parent
				cur_branch.leaf_count = Random.range_int(0,  tree_structure_config.max_leaf_count)
				cur_branch.collectable_holder_count = Random.range_int(0,  tree_structure_config.max_collectable_holder_count)
				#tree.children.append(cur_branch)
				plant_data.branchs_to_be_spawned.append(cur_branch)
		else:
			var i = 0
			
			#2: Aplica crescimento nos branchs ativos. Obs: caso já tenham crescido no máximo remove-os
			while i < plant_data.active_branchs.size():
				if plant_data.active_branchs[i].filled_percentage < 1:
					var result : BranchPointsResult = plant_data.active_branchs[i].instance.grow(grow_amount)
					if abs(result.points[-1].y + plant_data.active_branchs[i].instance.global_position.y - (self.get_parent().global_position.y + self.get_parent().size.y)) > cur_max_point.y:
						cur_max_point = (result.points[-1] + plant_data.active_branchs[i].instance.global_position - (self.get_parent().global_position + self.get_parent().size)).abs()
					#Crashs save cause of recursive features of SaveManager.save
					#if result.full_grown:
						#for child in plant_data.active_branchs[i].children:
							#if child.position_in_parent >= plant_data.active_branchs[i].filled_percentage:
								#plant_data.branchs_to_be_spawned.erase(plant_data.branchs_to_be_spawned)
						#plant_data.active_branchs.remove(i)
						#i-=1
				else:
					plant_data.active_branchs.remove_at(i)
					i-=1
				i+=1
			
			i=0
			var branch_to_be_spawned : Resource
			var branch_parent : Resource
			
			#3: Spawna os branchs na fila se for o caso
			var branchs_to_spawn_count = plant_data.branchs_to_be_spawned.size()
			while i < branchs_to_spawn_count:
				branch_to_be_spawned = plant_data.branchs_to_be_spawned[i]
				branch_parent = branch_to_be_spawned.parent
				if branch_parent.filled_percentage >= branch_to_be_spawned.position_in_parent:
					branch_count += 1
					#3.1: Spawna branch
					branch_to_be_spawned.global_pos = branch_parent.global_pos + branch_parent.instance.points[int((branch_parent.instance.points.size()-1) * branch_to_be_spawned.position_in_parent / branch_parent.filled_percentage)]
					var local_position = branch_parent.instance.points[int((branch_parent.instance.points.size()-1) * branch_to_be_spawned.position_in_parent / branch_parent.filled_percentage)]
					branch_to_be_spawned.instance = BranchLine.new(branch_to_be_spawned, tree_structure_config, collectables_controller)
					branch_to_be_spawned.instance.position = local_position
					branch_to_be_spawned.instance.width = 2
					branch_parent.instance.add_child(branch_to_be_spawned.instance)
					var result : BranchPointsResult = branch_to_be_spawned.instance.grow(grow_amount)
					if abs(result.points[-1].y + branch_to_be_spawned.instance.global_position.y - (self.get_parent().global_position.y + self.get_parent().size.y)) > cur_max_point.y:
						cur_max_point = (result.points[-1] + branch_to_be_spawned.instance.global_position - (self.get_parent().global_position + self.get_parent().size)).abs()
						
					#3.2: Coloca na fila de spawn os filhos da branch spawnada
					var branch_count = Random.range_int(1, tree_structure_config.max_branch_count)
					for j in range(branch_count):
						if cur_depth == branch_to_be_spawned.depth:
							cur_depth += 1
						var position_in_parent = Random.range_float(0, 1)
						cur_branch = BranchData.new()#BranchData.new(branch_to_be_spawned, cur_depth, position_in_parent, Random.range_int(0, tree_structure_config.max_leaf_count), Random.range_int(0,  tree_structure_config.max_collectable_holder_count))
						cur_branch.parent = branch_to_be_spawned
						cur_branch.depth = cur_depth
						cur_branch.position_in_parent = position_in_parent
						cur_branch.leaf_count = Random.range_int(0, tree_structure_config.max_leaf_count)
						cur_branch.collectable_holder_count = Random.range_int(0,  tree_structure_config.max_collectable_holder_count)
						#branch_to_be_spawned.children.append(cur_branch)
						plant_data.branchs_to_be_spawned.append(cur_branch)
					
					#3.3: Adiciona na fila de branchs ativos
					if branch_to_be_spawned.filled_percentage < 1:
						plant_data.active_branchs.append(branch_to_be_spawned)
					
					#3.4: Remove o branch da fila de spawn
					plant_data.branchs_to_be_spawned.remove_at(i)
					
					i-=1
					branchs_to_spawn_count -= 1
				i+=1
	Events.emit_signal("on_grow", tree_structure_config.tree_type, cur_max_point)

func _process(delta): 
	elapsed_time += delta
	if elapsed_time > 2:
		#print("Branch count: " + str(branch_count))
		elapsed_time = 0
	
func init_from_save():
	tree = plant_data.active_branchs[0] as BranchData
	tree.instance = BranchLine.new(tree, tree_structure_config, collectables_controller)
	tree.instance.width = 5
	tree.global_pos = self.global_position
	add_child(tree.instance)
	
	for i in range(1, plant_data.active_branchs.size()):
		var branch_to_be_spawned = plant_data.active_branchs[i] as BranchData
		var branch_parent = branch_to_be_spawned.parent as BranchData
		var local_position = branch_parent.instance.points[int((branch_parent.instance.points.size()-1) * branch_to_be_spawned.position_in_parent / branch_parent.filled_percentage)]
		branch_to_be_spawned.instance = BranchLine.new(branch_to_be_spawned, tree_structure_config, collectables_controller)
		branch_to_be_spawned.instance.position = local_position
		branch_to_be_spawned.instance.width = 2
		branch_parent.instance.add_child(branch_to_be_spawned.instance)
