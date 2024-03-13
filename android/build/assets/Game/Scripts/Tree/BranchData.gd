#Branch is defined by a Curve and its children
extends Resource
class_name BranchData

#Hierarchy
@export var depth : int
@export var parent: Resource #:BranchData

#Need to find a way to remove children: it is not possible to use it due to recursion in ResourceManager.save
#Substituir por index?
@export var children : Array#:BranchData # (Array, Resource)

#Position
@export var position_in_parent : float
@export var global_pos : Vector2

#Points
@export var initial_points : Array # (Array, Vector2)
@export var final_points : Array # (Array, Vector2)

#Growth
@export var filled_percentage : float = 0
@export var current_length : float = 0
@export var current_index : int = 0

#Leafs
@export var leaf_count : int
@export var leafs_data : Array #:LeafData # (Array, Resource)

#Collectable
@export var collectable_holder_count : int
@export var collectables_holders_data : Array #:CollectableHolderData # (Array, Resource)

@export var overlapping_ground_element_index : int

#Directional branch only
@export var to : Vector2
@export var has_grown_completely : bool = false

#Instance
var instance

func init(parent : BranchData, depth : int, position_in_parent: float, leaf_count : int, collectable_holder_count : int, to : Vector2 = Vector2.ZERO):
	self.parent = parent
	self.depth = depth
	self.position_in_parent = position_in_parent 
	self.leaf_count = leaf_count
	self.collectable_holder_count = collectable_holder_count
	self.to = to
