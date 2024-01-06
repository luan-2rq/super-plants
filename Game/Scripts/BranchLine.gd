extends Line2D
class_name BranchLine

#Branch data
var branch_data : BranchData

#Hierarchy
var parent : BranchLine
var children : Array = Array()

#Leaves
var leaf_count : int
var leaf_color : Color
var leaf_texture : Texture
var leafs : Array

#Collision
var static_body : StaticBody2D
var raycast : RayCast2DDraw

func _draw():
	# Draw the collision polygon in red
	var collision_polygon = static_body.get_child(0)
	if collision_polygon is CollisionPolygon2D:
		pass
		#draw_colored_polygon(collision_polygon.polygon, Color(1, 0, 0))
	
func _init(parent : BranchLine, branch_data : BranchData, leaf_count: int, leaf_texture: Texture, leaf_color: Color):
	self.branch_data = branch_data
	self.parent = parent
	#Leaf
	self.leaf_count = leaf_count
	self.leaf_color = leaf_color
	self.leaf_texture = leaf_texture

func _ready():
	static_body = StaticBody2D.new()
	add_child(static_body)
	
	raycast = RayCast2DDraw.new()
	raycast.global_position = self.global_position + points[-1] if points.size() > 0 else Vector2.ZERO
	raycast.enabled = true
	raycast.collide_with_areas = true
	add_child(raycast)
	
	#leafs
	for i in range(leaf_count):
		var position_on_branch = Random.range_float(0, 1)
		var rotation = Random.range_float(-PI, PI)
		leafs.append(Leaf.new(position_on_branch, Vector2.RIGHT.rotated(rotation)))

func add_leaf(leaf : Leaf):
	leaf.position = points[int(leaf.position_on_branch*(points.size()-1))]
	leaf.texture = leaf_texture
	leaf.rotation = rotation
	leaf.z_index = 1
	leaf.centered = false
	leaf.modulate = Color(0.01, 0.9, 0.4, 1)
	leaf.scale = Vector2(0.1, 0.1)
	add_child(leaf)

func add_point(position : Vector2, index : int = -1):
	if static_body.get_child(0) == null:
		var line_poly = Geometry.offset_polygon_2d(points, width/2)
		#print("Size: " + str(line_poly.size()))

		for poly in line_poly:
			var col = CollisionPolygon2D.new()
			col.polygon = poly
			static_body.add_child(col)
	else:
		pass
		#var new_polygon_points = expand(points[-1] if points.size() > 0 else Vector2.ZERO, position, width /2)
		#var new_polygon = static_body.get_child(0).polygon
		#for point in new_polygon_points:
			#new_polygon.push_back(point)
		#static_body.get_child(0).polygon = new_polygon
		#static_body.get_child(0).update()
	raycast.cast_to = (points[-1] - points[-2]).normalized() * 10 if points.size() > 2 else points[-1].normalized() * 10
	raycast.global_position =  self.global_position + points[-1]
		
	
	.add_point(position)
	var i = 0
	while i <  leafs.size():
		if leafs[i].position_on_branch >= branch_data.filled_percentage:
			add_leaf(leafs[i])
			leafs.remove(i)
			i-=1
		i+=1

#Points must be of size 2 >
func expand(point_a : Vector2, point_b : Vector2, delta : int) -> PoolVector2Array:
	var right_vec = (point_b - point_a).normalized().rotated(1.5708).normalized()
	var left_vec = (point_b - point_a).normalized().rotated(-1.5708).normalized()
	
	var result = PoolVector2Array([right_vec * point_b * delta, left_vec * point_b * delta])
	return result
	
#return true if has achived full growth. If it hits the bounds or another branch, it is cosidered as full growth
func grow(length : float, angle_range : float, initial_direction : Vector2, bounds : Resource) -> bool:
	#if depth == 0 and line != null and line.static_body != null and line.static_body.get_child(0) is CollisionPolygon2D:
		#var collision_polygon = line.static_body.get_child(0)
		#print(collision_polygon.polygon.size())
	var points_result : BranchPointsResult
	var full_grown
	if branch_data.final_points.size() == 0:
		branch_data.initial_points = generate_points(length, angle_range, initial_direction)
		branch_data.final_points = generate_curve_points(branch_data.initial_points, branch_data.bake_interval)
		
		branch_data.current_length += length
		branch_data.last_point_index = (branch_data.final_points.size()-1) * branch_data.current_length / branch_data.max_length
		branch_data.filled_percentage = float(branch_data.last_point_index) / branch_data.final_points.size()
		
		#setting correctly the max size 
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.last_point_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, bounds as Bounds)
		
		full_grown = processed_points.full_grown
		self.points = processed_points.points
	else:
		branch_data.current_length += length
		branch_data.last_point_index = (branch_data.final_points.size()-1) * branch_data.current_length / branch_data.max_length
		branch_data.filled_percentage = float(branch_data.last_point_index) / branch_data.final_points.size()
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.last_point_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, bounds as Bounds)
		
		full_grown = processed_points.full_grown
		self.points = processed_points.points
		
	raycast.cast_to = (self.points[-1] - self.points[-2]).normalized() * 10 if self.points.size() > 2 else self.points[-1].normalized() * 10
	raycast.global_position =  self.global_position + self.points[-1]
	
	if raycast.is_colliding():
		if raycast.get_collider() != static_body:
			full_grown = true
			raycast.enabled = false
			#line.static_body.set_physics_process(false)
			#line.static_body.set_process(false)
			#line.static_body.set_collision_layer_bit(0, false)
			#line.static_body.set_collision_mask_bit(0, false)
	if branch_data.current_length == branch_data.max_length:
		full_grown = true
	#Add leaf
	var i = 0
	while i <  leafs.size():
		if leafs[i].position_on_branch >= branch_data.filled_percentage:
			add_leaf(leafs[i])
			leafs.remove(i)
			i-=1
		i+=1

	var line_poly = Geometry.offset_polygon_2d(self.points, width/2)
	#print("Size: " + str(line_poly.size()))
	
	for poly in line_poly:
		var collision_polygon = static_body.get_child(0)
		if collision_polygon == null:
			var col = CollisionPolygon2D.new()
			col.polygon = poly
			static_body.add_child(col)
		else:
			pass
	return full_grown

func generate_points(length : float,  angle_range : float, initial_direction : Vector2) -> PoolVector2Array:
	var points = PoolVector2Array()
	
	var point_step = branch_data.max_length / branch_data.n_points
	var cur_dir = initial_direction
	var cur_point = points[-1] if self.points.size() > 0 else Vector2.ZERO
	points.append(cur_point)
	
	for i in range(branch_data.n_points - 1):
		points.append(points[-1] + cur_dir * point_step)
		var angle_to_rotate = Random.range_float(-angle_range, angle_range)
		cur_dir = cur_dir.rotated(angle_to_rotate)
		
	return points

func generate_curve_points(intial_points : PoolVector2Array, bake_inteval : float) -> PoolVector2Array:
	var curve = Curve2D.new()
	curve.bake_interval = bake_inteval
	curve.add_point(Vector2.ZERO)
	
	for i in range(1, intial_points.size() - 2):
		var in_out = (intial_points[i+1] - intial_points[i-1]) / 3
		curve.add_point(intial_points[i], -in_out, in_out)
		
	return curve.get_baked_points()

#Remove the points outside the bounds
func trim_points(points : PoolVector2Array, bounds : Bounds) -> BranchPointsResult:
	var full_grown : bool = false
	var cur_point_pos = branch_data.global_pos
	var new_size = 0
	for i in range(points.size()):
		new_size = i + 1
		cur_point_pos = branch_data.global_pos + points[i]
		var x_out_of_bounds = (bounds.min_x != -1 and cur_point_pos.x < bounds.min_x) or (bounds.max_x != -1 and cur_point_pos.x > bounds.max_x)
		var y_out_of_bounds = (bounds.min_y != -1 and cur_point_pos.y < bounds.min_y) or (bounds.max_y != -1 and cur_point_pos.y > bounds.max_y)
		if x_out_of_bounds or y_out_of_bounds:
			full_grown = true
			break
	points.resize(new_size)
	return BranchPointsResult.new(full_grown, points)

func add_branch_child(child):
	self.children.append(child)
