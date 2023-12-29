extends Line2D
class_name BranchLine

#Leaves
var leaf_count : int
var leaf_color : Color
var leaf_texture : Texture

#Variables used for growth purposes
var fill_percentage : float
var rest

var points_cache : PoolVector2Array

func _init(points : PoolVector2Array, leaf_count: int, leaf_texture: Texture, leaf_color: Color):
	#Line
	self.points = points
	self.points_cache = points
	
	#Leaf
	self.leaf_count = leaf_count
	self.leaf_color = leaf_color
	self.leaf_texture = leaf_texture

func _ready():
	#Add leaves
	for i in range(leaf_count):
		var position_on_branch = Random.range_float(0, 1)
		var rotation = Random.range_float(-PI, PI)
		add_leaf(position_on_branch, rotation)

func add_leaf(position_on_branch : float, rotation):
	var leaf_sprite = Leaf.new(position_on_branch, 0.1 * Vector2.ONE)
	leaf_sprite.position = points[int(position_on_branch*(points_cache.size()-1))]
	leaf_sprite.texture = leaf_texture
	leaf_sprite.rotation = rotation
	leaf_sprite.z_index = 1
	leaf_sprite.centered = false
	leaf_sprite.modulate = Color(0.01, 0.9, 0.4, 1)
	add_child(leaf_sprite)
	
func set_growth(growth : float):
	#Line growth
	var points_copy = Array(points_cache)
	self.points = points_copy.slice(0, (points_cache.size() - 1) * (growth))
	self.fill_percentage = growth
	#Leaf growth
	for child in get_children():
		if child is Sprite:
			child.position = points[int(child.position_on_branch*(points.size()-1))]
			child.scale = self.fill_percentage * child.default_scale
