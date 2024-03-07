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
var leafs_to_spawn : Array

#Collectables
var collectables_holders_to_spawn : Array
var collectables_controller : CollectablesController

func _init(branch_data : BranchData, tree_config : TreeStructureConfig, collectables_controller : CollectablesController = null):
	self.branch_data = branch_data
	self.tree_config = tree_config
	self.default_color = tree_config.stem_color
	self.collectables_controller = collectables_controller

func _ready():
	static_body = StaticBody2D.new()
	add_child(static_body)
	static_body.collision_layer = 2
	
	raycast = RayCast2DDraw.new()
	raycast.global_position = self.global_position + points[-1] if points.size() > 0 else Vector2.ZERO
	raycast.enabled = true
	raycast.collision_mask = 2
	raycast.collide_with_areas = true
	add_child(raycast)
	
	#Initialize points
	#if branch_data.initial_points.size() != 0:
		#If its not directional
		#branch_data.final_points = generate_curve_points(branch_data.initial_points, tree_config.bake_interval)
		
	var copy_final_points = branch_data.final_points.duplicate()
	copy_final_points.resize(int(branch_data.filled_percentage*branch_data.final_points.size()))
	self.points = copy_final_points
	
	#Initialize leafs
	if branch_data.leaf_count > 0:
		if branch_data.leafs_data.size() <= 0:
			for i in range(branch_data.leaf_count):
				var position_on_branch = Random.range_float(0, 1)
				var rot = Random.range_float(-PI, PI)
				var leaf_data = LeafData.new()
				leaf_data.pos_on_branch = position_on_branch
				leaf_data.rot = rot
				var leaf = Leaf.new(leaf_data)
				leafs_to_spawn.append(leaf)
				branch_data.leafs_data.append(leaf_data)
		else:
			for leaf_data in branch_data.leafs_data:
				var leaf = Leaf.new(leaf_data as LeafData)
				if branch_data.filled_percentage >= leaf.data.pos_on_branch:
					add_leaf(leaf)
				else:
					leafs_to_spawn.append(leaf)
					
	#Initialize collectables holders
	if branch_data.collectable_holder_count > 0:
		if branch_data.collectables_holders_data.size() <= 0:
			for i in range(branch_data.collectable_holder_count):
				var position_on_branch = Random.range_float(0, 1)
				var rot = Random.range_float(-PI, PI)
				var collectable_holder_data = CollectableHolderData.new()
				collectable_holder_data.pos_on_branch = position_on_branch
				collectable_holder_data.rot = rot
				var collectable_holder = tree_config.collectable_prefab.instance()
				collectable_holder.data = collectable_holder_data
				collectable_holder.collectables_controller = collectables_controller
				collectables_holders_to_spawn.append(collectable_holder)
				branch_data.collectables_holders_data.append(collectable_holder_data)
				#To do: set collectable holder config
		else:
			for collectable_holder_data in branch_data.collectables_holders_data:
				var collectable_holder = tree_config.collectable_prefab.instance()
				collectable_holder.data = collectable_holder_data
				collectable_holder.collectables_controller = collectables_controller
				if branch_data.filled_percentage >= collectable_holder.data.pos_on_branch:
					add_collectable_holder(collectable_holder)
				else:
					collectables_holders_to_spawn.append(collectable_holder)

func add_leaf(leaf : Leaf):
	leaf.position = self.points[int(leaf.data.pos_on_branch*(self.points.size()-1))]
	leaf.texture = tree_config.leaf_texture
	leaf.z_index = 1
	leaf.centered = false
	leaf.modulate = Color(0.01, 0.9, 0.4, 1)
	leaf.scale = Vector2(0.05, 0.05)
	add_child(leaf)
	
func add_collectable_holder(collectable_holder : CollectableHolder):
	collectable_holder.position = self.points[int(collectable_holder.data.pos_on_branch*(self.points.size()-1))]
	collectable_holder.z_index = 2
	add_child(collectable_holder)

func add_point(position : Vector2, index : int = -1):
	#if static_body.get_child(0) == null:
		#var line_poly = Geometry.offset_polygon_2d(points, width/2)
		#print("Size: " + str(line_poly.size()))

		#for poly in line_poly:
			#var col = CollisionPolygon2D.new()
			#col.polygon = poly
			#static_body.add_child(col)
	#else:
		#pass
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
	while i <  leafs_to_spawn.size():
		if branch_data.filled_percentage >=leafs_to_spawn[i].data.pos_on_branch:
			add_leaf(leafs_to_spawn[i])
			leafs_to_spawn.remove(i)
			i-=1
		i+=1
	i=0
	while i <  self.collectables_holders_to_spawn.size():
		if branch_data.filled_percentage >= collectables_holders_to_spawn[i].data.pos_on_branch:
			add_collectable_holder(collectables_holders_to_spawn[i])
			collectables_holders_to_spawn.remove(i)
			i-=1
		i+=1
	
func grow(length) -> BranchPointsResult:
	var points_result : BranchPointsResult = BranchPointsResult.new(false, PoolVector2Array())
	
	if branch_data.final_points.size() == 0:
		branch_data.initial_points = generate_points_random_direction(tree_config.branch_angle_range, tree_config.initial_branch_direction)
		branch_data.final_points = generate_curve_points(branch_data.initial_points, tree_config.bake_interval)
		
		branch_data.current_length += length
		branch_data.current_index = clamp((branch_data.final_points.size()-1) * branch_data.current_length / tree_config.max_branch_length, 0, branch_data.final_points.size() -1)
		branch_data.filled_percentage = float(branch_data.current_index) / branch_data.final_points.size()
		
		#setting correctly the max size 
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.current_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, tree_config.bounds as Bounds)
		
		points_result.full_grown = processed_points.full_grown
		points_result.points = processed_points.points
		self.points = processed_points.points
	else:
		branch_data.current_length += length
		branch_data.current_index = clamp((branch_data.final_points.size()-1) * branch_data.current_length / tree_config.max_branch_length, 0,branch_data.final_points.size()-1)
		branch_data.filled_percentage = float(branch_data.current_index) / branch_data.final_points.size()
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.current_index+1):
			cur_points.append(branch_data.final_points[i])
			
		var processed_points : BranchPointsResult = trim_points(cur_points, tree_config.bounds as Bounds)
		
		points_result.full_grown = processed_points.full_grown
		points_result.points = processed_points.points
		self.points = processed_points.points
		
	raycast.cast_to = (self.points[-1] - self.points[-2]).normalized() * 10 if self.points.size() > 2 else self.points[-1].normalized() * 10
	raycast.global_position =  self.global_position + self.points[-1]
	
	#Verifica colisões com outras branchs
	#if raycast.is_colliding():
		#if raycast.get_collider() != static_body and !raycast.get_collider().is_in_group(str(tree_config.get_instance_id())):
			#pass
			#points_result.full_grown = true
			#raycast.enabled = false
			
	if branch_data.current_length == tree_config.max_branch_length:
		points_result.full_grown = true
	#Add leaf
	var i = 0
	while i <  leafs_to_spawn.size():
		if branch_data.filled_percentage >= leafs_to_spawn[i].data.pos_on_branch:
			add_leaf(leafs_to_spawn[i])
			leafs_to_spawn.remove(i)
			i-=1
		i+=1
	i=0
	while i <  self.collectables_holders_to_spawn.size():
		if branch_data.filled_percentage >= collectables_holders_to_spawn[i].data.pos_on_branch:
			add_collectable_holder(collectables_holders_to_spawn[i])
			collectables_holders_to_spawn.remove(i)
			i-=1
		i+=1

	var line_poly = Geometry.offset_polygon_2d(self.points, width/2)
	#if static_body.get_child_count() > 0:
		#static_body.get_child(0).polygon = line_poly
	#print("Size: " + str(line_poly.size()))
	
	#for poly in line_poly:
		#if static_body.get_child_count() <= 0:
			#var col = CollisionPolygon2D.new()
			#col.add_to_group(str(tree_config.get_instance_id()), true)
			#col.polygon = line_poly[0]
			#static_body.add_child(col)
	return points_result

#Param to is global position
func grow_directional(grow_amount : float):
	var epsilon = 0.0001
	if abs(1 - branch_data.filled_percentage) > epsilon:
		
		if branch_data.final_points.size() == 0:
			branch_data.initial_points = generate_points_directionally_to(Vector2.ZERO, tree_config.branch_angle_range)
			branch_data.final_points = generate_curve_points(branch_data.initial_points, tree_config.bake_interval)
		branch_data.current_length += grow_amount
		
		for i in range(branch_data.current_index, branch_data.final_points.size()):
			if branch_data.final_points[i].length() >= branch_data.current_length:
				var final_points_size = branch_data.final_points.size()
				var point = branch_data.final_points[i]
				var total_length = branch_data.final_points[i].length()
				var cur_length = branch_data.current_length
				branch_data.current_index = i
				break
			elif i == branch_data.final_points.size() - 1:
				var final_points_size = branch_data.final_points.size()
				var point = branch_data.final_points[i]
				var total_length = branch_data.final_points[i].length()
				var cur_length = branch_data.current_length
				branch_data.current_index = i
		
		var cur_points = self.points
		for i in range(self.points.size(), branch_data.current_index+1):
			cur_points.push_back(branch_data.final_points[i])
			
		branch_data.filled_percentage = float(branch_data.current_index + 1) / branch_data.final_points.size()
		
		self.points = cur_points
		
		return false
	else:
		return true

func generate_points_random_direction(angle_range : float, initial_direction : Vector2) -> PoolVector2Array:
	var points = PoolVector2Array()
	
	var point_step = tree_config.max_branch_length / tree_config.n_points_per_branch
	var cur_dir = initial_direction
	var cur_point = points[-1] if self.points.size() > 0 else Vector2.ZERO
	points.append(cur_point)
	
	for i in range(tree_config.n_points_per_branch - 1):
		points.append(points[-1] + cur_dir * point_step)
		var angle_to_rotate = Random.range_float(-angle_range, angle_range)
		cur_dir = cur_dir.rotated(angle_to_rotate)
		
	return points

func generate_points_directionally_to(initial_point : Vector2, angle_range : float):
	var result = PoolVector2Array()
	var final_point = self.branch_data.to - self.global_position 
	var total_points : int = final_point.length() * tree_config.initial_points_density
	var point_distance = final_point.length() / total_points
	
	var direction = final_point.normalized()
	var length = final_point.length()
	
	result.append(initial_point)
	result.append(final_point)
	
	var n_in_between_points : int = total_points - 2 if (total_points - 2) % 2 == 0 else total_points - 3
	
	var min_length = point_distance / 2
	var max_length = point_distance * 2
	var total_length = n_in_between_points
	
	var lengths = random_lengths(n_in_between_points, min_length, max_length, total_length)
	
	var max_curve_distance = 30
	var min_curve_distance = 30 / 2
	
	var curve_points = 0
	#for i in range(n_in_between_points):
		#var cur_point
		#if i%2 == 0:
			#if curve_points%2==0:
				#cur_point = result[-1] + lengths[i] * direction
				#cur_point.x += max_curve_distance
			#else:
				#cur_point = result[-1] + lengths[i] * direction
				#cur_point.x -= max_curve_distance
			#curve_points+=1
		#else:
			#cur_point = result[-1] + lengths[i] * direction
			#cur_point.x = 0
		#result.insert(i+1, cur_point)
		
	#print("Tamanho: "+ str(result.size()))
	##To do: add logic to make it curvilinear
	#var cur_dir = final_point.normalized()
	var cur_point
	for i in range(1, total_points - 2):
		#var angle_to_rotate = Random.range_float(-angle_range, angle_range)
		#cur_dir = cur_dir.rotated(angle_to_rotate)
		cur_point = result[i-1] + point_distance * direction
		result.insert(i, cur_point)
	return result
	
func generate_curve_points(initial_points : PoolVector2Array, bake_inteval : float) -> PoolVector2Array:
	var curve = Curve2D.new()
	curve.bake_interval = bake_inteval
	curve.add_point(initial_points[0])
	
	for i in range(1, initial_points.size()-1):
		var in_out = (initial_points[i+1] - initial_points[i-1]) / 3
		curve.add_point(initial_points[i], -in_out, in_out)
		
	curve.add_point(initial_points[-1])
		
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

#Points must be of size 2 >
func expand(point_a : Vector2, point_b : Vector2, delta : int) -> PoolVector2Array:
	var right_vec = (point_b - point_a).normalized().rotated(1.5708).normalized()
	var left_vec = (point_b - point_a).normalized().rotated(-1.5708).normalized()
	
	var result = PoolVector2Array([right_vec * point_b * delta, left_vec * point_b * delta])
	return result
	
#Calculate N random length values, that are between x and y and sum to z
func random_lengths(n: int, min_length: float, max_length: float, total_length: float) -> Array:
	var values = []
	var total_sum = 0.0

	# Generate N random values between range x and y
	for i in range(n):
		var random_value = rand_range(min_length, max_length)
		values.append(random_value)
		total_sum += random_value

	# Adjust values so the sum is z
	var scale_factor = total_length / total_sum
	for i in range(n):
		values[i] *= scale_factor

	return values
