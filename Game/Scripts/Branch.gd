#Branch is defined by a Curve and its children
extends Node2D
class_name Branch

var parent : Branch
var children : Array = Array()
var depth : int

var position_in_parent : float
var pos : Vector2

#Curve that defines the branch
var points : PoolVector2Array
var line : BranchLine
	
func _init(parent: Branch, position_in_parent: float, depth : int, pos : Vector2):
	self.position_in_parent = position_in_parent 
	self.parent = parent
	self.depth = depth
	self.pos = pos

func generate(branch_length : float, points_per_unit : int, initial_point_step : float, angle_range : float, initial_direction : Vector2, bounds : Resource):
	generate_curve_points(generate_points(branch_length, points_per_unit, initial_point_step, angle_range, initial_direction), bounds as Bounds)

func generate_points(branch_length : float, points_per_unit : int, initial_point_step : float, angle_range : float, initial_direction : Vector2) -> PoolVector2Array:
	var points = PoolVector2Array()
	var cur_dir = initial_direction
	var cur_point = Vector2.ZERO
	points.append(cur_point)
	
	for i in range(branch_length * points_per_unit):
		points.append(points[-1] + cur_dir * initial_point_step)
		var angle_to_rotate = Random.range_float(-angle_range, angle_range)
		cur_dir = rotate_vec(cur_dir, angle_to_rotate)
	return points

func generate_curve_points(points, bounds : Bounds):
	var curve = Curve2D.new()
	curve.bake_interval = 1.0
	for i in range(points.size()):
		curve.add_point(points[i])
	self.points = trim_points(curve.get_baked_points(), bounds)

#Remove the points outside the bounds
func trim_points(points : PoolVector2Array, bounds : Bounds):
	var cur_point_pos = pos
	var new_size = 0
	for i in range(points.size()):
		new_size = i + 1
		cur_point_pos = pos + points[i]
		var x_out_of_bounds = (bounds.min_x != -1 and cur_point_pos.x < bounds.min_x) or (bounds.max_x != -1 and cur_point_pos.x > bounds.max_x)
		var y_out_of_bounds = (bounds.min_y != -1 and cur_point_pos.y < bounds.min_y) or (bounds.max_y != -1 and cur_point_pos.y > bounds.max_y)
		if x_out_of_bounds or y_out_of_bounds:
			break
	points.resize(new_size)
	return points
	
func set_line(line):
	self.line = line
	
func add_branch_child(child):
	self.children.append(child)
	
func rotate_vec(vec : Vector2, angle_rad : float) -> Vector2:
	var x = vec.x * cos(angle_rad) + vec.y * sin(angle_rad)
	var y = vec.x * -sin(angle_rad) + vec.y * cos(angle_rad)
	return Vector2(x, y)


