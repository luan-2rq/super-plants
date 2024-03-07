extends Resource
class_name TreeStructureConfig

#Structural

export var __ = "Structural"

export var max_depth : int = 1000
export var max_height : int

export var bake_interval : float = 1

export(float, -3.14, 3.14) var branch_angle_range : float = 1.5

export var initial_branch_count : int = 4

export var bounds : Resource

export(Enums.TreeType) var tree_type

export(float) var initial_points_density = 0.2

#Visual
export var ___ = "Visual"
export var stem_color : Color
