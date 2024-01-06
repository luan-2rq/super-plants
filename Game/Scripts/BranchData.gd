#Branch is defined by a Curve and its children
extends Node2D
class_name BranchData

#Hierarchy
var depth : int

#Position
var position_in_parent : float
var global_pos : Vector2

#Length n' density
var max_length : float
var n_points : int
var bake_interval : float

#Points
var initial_points : PoolVector2Array
var final_points : PoolVector2Array

#Growth
var filled_percentage : float = 0
var current_length : float = 0
var last_point_index : int = 0


func _init(depth : int, position_in_parent: float, max_length : float, n_points : int, bake_interval : float):
	self.position_in_parent = position_in_parent 
	self.depth = depth
	self.max_length = max_length
	self.n_points = n_points
	self.bake_interval = bake_interval

