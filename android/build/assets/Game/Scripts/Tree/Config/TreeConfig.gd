extends TreeStructureConfig
class_name TreeConfig

@export var n_points_per_branch : float = 5
@export var initial_branch_direction = Vector2(0, 1)

@export var max_branch_count : int = 3

@export var initial_branch_length = 80
@export var max_branch_length : float = 50

#VISUALS 
@export var max_leaf_count : int
@export var leaf_texture: Texture2D
@export var leaf_color : Color

#Collectable
@export var max_collectable_holder_count : int
@export var collectable_texture: Texture2D
@export var collectable_prefab: PackedScene
#export var collectable_color : Color
