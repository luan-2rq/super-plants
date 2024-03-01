extends TreeStructureConfig
class_name TreeConfig

export var n_points_per_branch : float = 5
export var initial_branch_direction = Vector2(0, 1)

export var max_branch_count : int = 3

export var initial_branch_length = 80
export var max_branch_length : float = 50

#VISUALS 
export var max_leaf_count : int
export(Texture) var leaf_texture : Texture
export var leaf_color : Color

#Collectable
export var max_collectable_count : int
export(Texture) var collectable_texture : Texture
export(PackedScene) var collectable_prefab
#export var collectable_color : Color
