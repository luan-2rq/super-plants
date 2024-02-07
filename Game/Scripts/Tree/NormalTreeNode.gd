#General purpose tree structure, serves for both root and trees
class_name NormalTreeNode
extends Node2D

#Config
export var tree_structure_config : Resource

#Data
var tree : BranchData
var cur_depth = 0

var branchs_to_be_spawned : Array = Array()#BranchData
var active_branchs : Array = Array()#BranchData

var cur_max_point = Vector2.ZERO

var grow_step = 10
	
#FUNÇÃO INCREMENTAL PARA CRESCER A ÁRVORE: -> Sem Retorno
# 1: Gera o primeiro branch
# 2: Aplica crescimento nos branchs ativos
# 3: Spawna os branchs filhos, quando for o caso
func grow_tree():
	var cur_branch
	if cur_depth <= tree_structure_config.max_depth:
		#1: Gera primeiro branch e coloca os filhos na filha de spawn
		if tree == null:
			tree = BranchData.new(null, cur_depth, 0, tree_structure_config.initial_branch_length, tree_structure_config.n_points_per_branch, tree_structure_config.bake_interval, 0)
			tree.instance = BranchLine.new(tree, tree_structure_config)
			tree.instance.width = 5
			tree.global_pos = self.global_position
			active_branchs.append(tree)
			add_child(tree.instance)
			
			tree.instance.grow(tree_structure_config.step_length)
			cur_depth += 1
			for i in range(tree_structure_config.initial_branch_count):
				var position_in_parent = Random.range_float(0, 1)
				cur_branch = BranchData.new(tree, cur_depth, position_in_parent, tree_structure_config.max_branch_length, tree_structure_config.n_points_per_branch, tree_structure_config.bake_interval, Random.range_int(0,  tree_structure_config.max_leaf_count))
				tree.add_branch_child(cur_branch)
				branchs_to_be_spawned.append(cur_branch)
		else:
			var i = 0
			
			#2: Aplica crescimento nos branchs ativos. Obs: caso já tenham crescido no máximo remove-os
			while i < active_branchs.size():
				if active_branchs[i].filled_percentage < 1:
					var result : BranchPointsResult = active_branchs[i].instance.grow(tree_structure_config.step_length)
					if (result.points[-1].y * tree_structure_config.initial_branch_direction.y + active_branchs[i].instance.global_position.y - tree.instance.global_position.y) * tree_structure_config.initial_branch_direction.y > cur_max_point.y:
						cur_max_point = ((result.points[-1] * tree_structure_config.initial_branch_direction.y) + active_branchs[i].instance.global_position - tree.instance.global_position) * tree_structure_config.initial_branch_direction.y
					if result.full_grown:
						for child in active_branchs[i].children:
							if child.position_in_parent >= active_branchs[i].filled_percentage:
								branchs_to_be_spawned.erase(branchs_to_be_spawned)
						active_branchs.remove(i)
						i-=1
				else:
					active_branchs.remove(i)
					i-=1
				i+=1
			
			i=0
			var branch_to_be_spawned : BranchData
			var branch_parent : BranchData
			
			#3: Spawna os branchs na fila se for o caso
			var branchs_to_spawn_count = branchs_to_be_spawned.size()
			while i < branchs_to_spawn_count:
				branch_to_be_spawned = branchs_to_be_spawned[i]
				branch_parent = branchs_to_be_spawned[i].parent
				if branch_parent.filled_percentage >= branch_to_be_spawned.position_in_parent:
					#3.1: Spawna branch
					branch_to_be_spawned.global_pos = branch_parent.global_pos + branch_parent.instance.points[int((branch_parent.instance.points.size()-1) * branch_to_be_spawned.position_in_parent / branch_parent.filled_percentage)]
					var local_position = branch_parent.instance.points[int((branch_parent.instance.points.size()-1) * branch_to_be_spawned.position_in_parent / branch_parent.filled_percentage)]
					branch_to_be_spawned.instance = BranchLine.new(branch_to_be_spawned, tree_structure_config)
					branch_to_be_spawned.instance.position = local_position
					branch_to_be_spawned.instance.width = 2
					branch_parent.instance.add_child(branch_to_be_spawned.instance)
					var result : BranchPointsResult = branch_to_be_spawned.instance.grow(tree_structure_config.step_length)
					if (result.points[-1].y * tree_structure_config.initial_branch_direction.y + branch_to_be_spawned.instance.global_position.y - tree.instance.global_position.y) * tree_structure_config.initial_branch_direction.y > cur_max_point.y:
						cur_max_point = ((result.points[-1] * tree_structure_config.initial_branch_direction.y)+ branch_to_be_spawned.instance.global_position - tree.instance.global_position) * tree_structure_config.initial_branch_direction.y
						
					#3.2: Coloca na fila de spawn os filhos da branch spawnada
					var branch_count = Random.range_int(1, tree_structure_config.max_branch_count)
					for j in range(branch_count):
						if cur_depth == branch_to_be_spawned.depth:
							cur_depth += 1
						var position_in_parent = Random.range_float(0, 1)
						cur_branch = BranchData.new(branch_to_be_spawned, cur_depth, position_in_parent, tree_structure_config.max_branch_length, tree_structure_config.n_points_per_branch, tree_structure_config.bake_interval, Random.range_int(0, tree_structure_config.max_leaf_count))
						branch_to_be_spawned.add_branch_child(cur_branch)
						branchs_to_be_spawned.append(cur_branch)
					
					#3.3: Adiciona na fila de branchs ativos
					if branch_to_be_spawned.filled_percentage < 1:
						active_branchs.append(branch_to_be_spawned)
					
					#3.4: Remove o branch da fila de spawn
					branchs_to_be_spawned.remove(i)
					
					i-=1
					branchs_to_spawn_count -= 1
				i+=1
	Events.emit_signal("on_grow", tree_structure_config.tree_type, cur_max_point)


func _process(delta): 
	#tree_structure_config.step_length = grow_step * delta
	grow_tree()
	
func init(data):
	tree = data[0]
	active_branchs.append(tree)
	branchs_to_be_spawned = data

func _on_Button_pressed():
	grow_tree()
