extends Resource
class_name TreeConfig

export var step_length : int = 10

#Structural

export var __ = "Structural"
export var max_depth : int = 1000
export var max_height : int 

export(Enums.TreeType) var tree_type

export var n_points_per_branch : float = 5
export var bake_interval : float = 1

export(float, -3.14, 3.14) var branch_angle_range : float = 1.5
export var initial_branch_direction = Vector2(0, 1)

export var initial_branch_count : int = 4
export var max_branch_count : int = 3

export var initial_branch_length = 80
export var max_branch_length : float = 50

export var bounds : Resource

#Visual
export var ___ = "Visual"
export var stem_color : Color

export var max_leaf_count : int
export(Texture) var leaf_texture : Texture
export var leaf_color : Color
