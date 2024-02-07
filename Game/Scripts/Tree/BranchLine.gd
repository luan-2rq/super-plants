extends Line2D
class_name BranchLine

#Branch data
var branch_data : BranchData
var tree_config : TreeStructureConfig

#Collision
var static_body : StaticBody2D
var raycast : RayCast2DDraw

#VISUALS 
#Leaves
var leafs : Array

func _init(branch_data : BranchData, tree_config : TreeStructureConfig):
	self.branch_data = branch_data
	self.tree_config = tree_config
	self.default_color = tree_config.stem_color

func _ready():
	static_body = StaticBody2D.new()
	add_child(static_body)
	
	raycast = RayCast2DDraw.new()
	raycast.global_position = self.global_position + points[-1] if points.size() > 0 else Vector2.ZERO
	raycast.enabled = true
	raycast.collision_mask = 2
	raycast.collide_with_areas = true
	add_child(raycast)
	
	#leafs
	for i in range(branch_data.leaf_count):
		var position_on_branch = Random.range_float(0, 1)
		var rotation = Random.range_float(-PI, PI)
		leafs.append(Leaf.new(position_on_branch, Vector2.RIGHT.rotated(rotation)))

func add_leaf(leaf : Leaf):
	leaf.position = points[int(leaf.position_on_branch*(points.size()-1))]
	leaf.texture = tree_config.leaf_texture
	leaf.rotation = rotation
	leaf.z_index = 1
	leaf.centered = false
	leaf.modulate = Color(0.01, 0.9, 0.4, 1)
	leaf.scale = Vector2(0.05, 0.05)
	add_child(leaf)
	
func add_collectable():
	pass

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
	
func grow(length) -> BranchPointsResult:
	var points_result : BranchPointsResult = BranchPointsResult.new(false, PoolVector2Array())
	
	if branch_data.final_points.size() == 0:
		branch_data.initial_points = generate_points_random_direction(tree_config.branch_angle_range, tree_config.initial_branch_direction)
		branch_data.final_points = generate_curve_points(branch_data.initial_points, branch_data.bake_interval)
		
		branch_data.current_length += length
		branch_data.last_point_index = clamp((branch_data.final_points.size()-1) * branch_data.current_length / branch_data.max_length, 0, branch_data.final_points.size() -1)
		branch_data.filled_percentage = float(branch_data.last_point_index) / branch_data.final_points.size()
		
		#setting correctly the max size 
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.last_point_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, tree_config.bounds as Bounds)
		
		points_result.full_grown = processed_points.full_grown
		points_result.points = processed_points.points
		self.points = processed_points.points
	else:
		branch_data.current_length += length
		branch_data.last_point_index = clamp((branch_data.final_points.size()-1) * branch_data.current_length / branch_data.max_length, 0,branch_data.final_points.size()-1)
		branch_data.filled_percentage = float(branch_data.last_point_index) / branch_data.final_points.size()
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.last_point_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, tree_config.bounds as Bounds)
		
		points_result.full_grown = processed_points.full_grown
		points_result.points = processed_points.points
		self.points = processed_points.points
		
	raycast.cast_to = (self.points[-1] - self.points[-2]).normalized() * 10 if self.points.size() > 2 else self.points[-1].normalized() * 10
	raycast.global_position =  self.global_position + self.points[-1]
	
	#Verifica colisões com outras branchs
	if raycast.is_colliding():
		if raycast.get_collider() != static_body and !raycast.get_collider().is_in_group(str(tree_config.get_instance_id())):
			points_result.full_grown = true
			raycast.enabled = false
			
	if branch_data.current_length == branch_data.max_length:
		points_result.full_grown = true
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
		if static_body.get_child_count() <= 0:
			var col = CollisionPolygon2D.new()
			col.add_to_group(str(tree_config.get_instance_id()), true)
			col.polygon = poly
			static_body.add_child(col)
			static_body.collision_layer = 2
	return points_result

func grow_directional(length, direction : Vector2):
	branch_data.current_length += length
	
	if branch_data.final_points.size() == 0:
		branch_data.initial_points = generate_points_directional(length, direction, Vector2.ZERO, tree_config.branch_angle_range)
		branch_data.final_points = generate_curve_points(branch_data.initial_points, tree_config.bake_interval)
		
		self.points = branch_data.final_points
	else:
		var initial_point = branch_data.initial_points[-1]
		var new_initial_points = generate_points_directional(length, direction, initial_point, tree_config.branch_angle_range)
		var new_final_points = generate_curve_points(new_initial_points, tree_config.bake_interval)
		new_initial_points.remove(0)
		new_final_points.remove(0)
		branch_data.initial_points.append_array(new_initial_points)
		branch_data.final_points.append_array(new_final_points)
		self.points = branch_data.final_points

func generate_points_random_direction(angle_range : float, initial_direction : Vector2) -> PoolVector2Array:
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

func generate_points_directional(length, direction : Vector2, initial_point : Vector2, angle_range : float):
	var result = PoolVector2Array()
	var final_point = initial_point + length * direction
	var point_distance = length / tree_config.n_points_per_step
	
	result.append(initial_point)
	result.append(final_point)
	
	var cur_dir = direction
	var cur_point
	for i in range(1, tree_config.n_points_per_step - 1):
		var angle_to_rotate = Random.range_float(-angle_range, angle_range)
		cur_dir = cur_dir.rotated(angle_to_rotate)
		cur_point = result[i-1] + point_distance * cur_dir
		result.insert(i, cur_point)
	return result
	
func generate_curve_points(initial_points : PoolVector2Array, bake_inteval : float) -> PoolVector2Array:
	var curve = Curve2D.new()
	curve.bake_interval = bake_inteval
	curve.add_point(initial_points[0])
	
	for i in range(1, initial_points.size()- 2):
		var in_out = (initial_points[i+1] - initial_points[i-1]) / 3
		curve.add_point(initial_points[i], -in_out, in_out)
		
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

#DEBUGGGING
func _draw():
	# Draw the collision polygon in red
	var collision_polygon = static_body.get_child(0)
	if collision_polygon is CollisionPolygon2D:
		pass
		#draw_colored_polygon(collision_polygon.polygon, Color(1, 0, 0))
