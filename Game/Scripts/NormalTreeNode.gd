#General purpose tree structure, serves for both root and trees
class_name NormalTreeNode
extends Node2D

#To do: separar em visual settings e other settings

export var __ = 'Tree Settings'
export var max_depth : int = 8
export(float, -3.14, 3.14) var angle_range : float = 1.5
export var stem_color : Color

export var ___ = 'Branches'
export var step_length : int = 10
export var initial_branch_length = 140
export var max_branch_length : float = 200
export var initial_branch_count : int = 4
export var max_branch_count : int = 3
export var initial_branch_direction = Vector2(0, 1)

export var ____ = 'Leaves'
export var leaf_count : int
export(Texture) var leaf_texture : Texture
export var leaf_color : Color

export var _____ = 'Points Settings'
export var n_points : float = 5
export var bake_interval : float = 1

export var ______ = 'Growth Settings'
export var growth : float = 1
export var growth_rate = 0.01

export var bounds : Resource
var branchs_to_be_spawned : Array = Array()
var active_branchs : Array = Array()

var tree : BranchLine
var depth = 0

func _ready():
	pass
	
#FUNCTIONS TO GENERATE TREE

func grow_tree():
	#Gere o primeiro branch e coloque os próximos branch na fila de branchs_to_be_spawned
	print("Branchs to spawn: " + str(branchs_to_be_spawned.size()))
	print("Branchs active: " + str(active_branchs.size()))
	var cur_branch_data
	var cur_branch
	if tree == null:
		cur_branch_data = BranchData.new(depth, 0, initial_branch_length, n_points, bake_interval)
		tree = BranchLine.new(null, cur_branch_data, 0, leaf_texture, leaf_color)
		tree.width = 5
		tree.branch_data.global_pos = self.global_position
		active_branchs.append(tree)
		add_child(tree)
		
		tree.grow(step_length, angle_range, initial_branch_direction, bounds)
		

		
		depth += 1
		for i in range(initial_branch_count):
			var position_in_parent = Random.range_float(0, 1)
			cur_branch_data = BranchData.new(depth, position_in_parent, max_branch_length, n_points, bake_interval)
			cur_branch = BranchLine.new(tree, cur_branch_data, Random.range_int(0, leaf_count), leaf_texture, leaf_color)
			cur_branch.width = 2
			tree.add_branch_child(cur_branch)
			branchs_to_be_spawned.append(cur_branch)
	else:
		var i = 0
		
		#Continue a preencher os branchs ativos, caso não esteja out_of_bounds
		while i < active_branchs.size():
			if active_branchs[i].branch_data.filled_percentage < 1:
				var full_grown : bool = active_branchs[i].grow(step_length, angle_range, initial_branch_direction, bounds)
				if full_grown:
					for child in active_branchs[i].children:
						if child.branch_data.position_in_parent >= active_branchs[i].branch_data.filled_percentage:
							branchs_to_be_spawned.erase(branchs_to_be_spawned)
					active_branchs.remove(i)
					i-=1
			else:
				active_branchs.remove(i)
				i-=1
			i+=1
		
		i=0
		var branch_to_be_spawned : BranchLine
		var branch_parent : BranchLine
		
		#Verifica se os branchs em fila podem ser spawnados, caso sim os spawna
		var branchs_to_spawn_count = branchs_to_be_spawned.size()
		while i < branchs_to_spawn_count:
			branch_to_be_spawned = branchs_to_be_spawned[i]
			branch_parent = branchs_to_be_spawned[i].parent
			if branch_parent.branch_data.filled_percentage >= branch_to_be_spawned.branch_data.position_in_parent:
				#Spawna branch
				branch_to_be_spawned.branch_data.global_pos = branch_parent.branch_data.global_pos + branch_parent.points[int((branch_parent.points.size()-1) * branch_to_be_spawned.branch_data.position_in_parent / branch_parent.branch_data.filled_percentage)]
				var local_position = branch_parent.points[int((branch_parent.points.size()-1) * branch_to_be_spawned.branch_data.position_in_parent / branch_parent.branch_data.filled_percentage)]
				branch_to_be_spawned.position = local_position
				branch_parent.add_child(branch_to_be_spawned)
				var full_grow : bool = branch_to_be_spawned.grow(step_length, angle_range, initial_branch_direction, bounds)
				
				#Coloca na fila de spawn os filhos da branch spawnada
				var branch_count = Random.range_int(1, max_branch_count)
				for j in range(branch_count):
					var position_in_parent = Random.range_float(0, 1)
					cur_branch_data = BranchData.new(depth, position_in_parent, max_branch_length, n_points, bake_interval)
					cur_branch = BranchLine.new(branch_to_be_spawned, cur_branch_data, Random.range_int(0, leaf_count), leaf_texture, leaf_color)
					cur_branch.width = 2
					branch_to_be_spawned.add_branch_child(cur_branch)
					branchs_to_be_spawned.append(cur_branch)
					

				
				#Adiciona na fila de branchs ativos
				if branch_to_be_spawned.branch_data.filled_percentage < 1:
					active_branchs.append(branch_to_be_spawned)
				
				#Remove o branch da fila
				branchs_to_be_spawned.remove(i)
				
				i-=1
				branchs_to_spawn_count -= 1
			i+=1


func _on_Button_pressed():
	grow_tree()
