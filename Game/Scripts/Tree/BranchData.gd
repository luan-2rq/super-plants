#Branch is defined by a Curve and its children
extends Object
class_name BranchData

#Hierarchy
var depth : int
var parent : BranchData
var children : Array

#Position
var position_in_parent : float
var global_pos : Vector2

#Pode ser passado por parâmetro#
#Length and density
var max_length : float
var n_points : int
var bake_interval : float

#Points
var initial_points : Array
var final_points : Array

#Growth
var filled_percentage : float = 0
var current_length : float = 0
var last_point_index : int = 0

#Leafs
var leaf_count : int

#Collectable
var collectable_count : int

#Instance
var instance

var to : Vector2

func _init(parent : BranchData, depth : int, position_in_parent: float, max_length : float, n_points : int, bake_interval : float, leaf_count : int, collectable_count : int, to : Vector2 = Vector2.ZERO):
	self.parent = parent
	self.depth = depth
	self.position_in_parent = position_in_parent 
	self.max_length = max_length
	self.n_points = n_points
	self.bake_interval = bake_interval
	self.leaf_count = leaf_count
	self.collectable_count = collectable_count
	self.to = to

func add_branch_child(child):
	self.children.append(child)
