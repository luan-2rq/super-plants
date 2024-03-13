extends Node2D

var default_quadrant_polygon: Array = []
@onready var Pol = preload("res://External/Terrain/Pol.tscn")

func _ready():
	init_quadrant()


func init_quadrant():
	"""
	Initiates the default (square) Pol
	"""
	self.add_child(_new_pol(default_quadrant_polygon))


func reset_quadrant():
	"""
	Removes all collision polygons
	and initiates the default Pol
	"""
	for pol in self.get_children():
		pol.free()
	init_quadrant()


func carve(clipping_polygon):
	"""
	Carves the clipping_polygon away from the quadrant
	"""
	for pol in self.get_children():
		var clipped_polygons = Geometry2D.clip_polygons(pol.polygon, clipping_polygon)
		var n_clipped_polygons = len(clipped_polygons)
		match n_clipped_polygons:
			0:
				# clipping_polygon completely overlaps pol
				pol.free()
			1:
				# Clipping produces only one polygon
				pol.set_polygon(clipped_polygons[0])
			2:
				# Check if you carved a hole (one of the two polygons
				# is clockwise). If so, split the polygon in two that
				# together make a "hollow" collision shape
				if _is_hole(clipped_polygons):
					# split and add
					for p in _split_polygon(clipping_polygon):
						var new_pol = _new_pol(
							Geometry2D.intersect_polygons(p, pol.polygon)[0]
							)
						self.add_child(new_pol)
					pol.free()
				# if its not a hole, behave as in match _
				else:
					pol.set_polygon(clipped_polygons[0])
					for i in range(n_clipped_polygons-1):
						self.add_child(_new_pol(clipped_polygons[i+1]))
			
			# if more than two polygons, simply add all of
			# them to the quadrant
			_:
				pol.set_polygon(clipped_polygons[0])
				for i in range(n_clipped_polygons-1):
					self.add_child(_new_pol(clipped_polygons[i+1]))


func add(_adding_polygon):
	"""
	TODO
	"""
	pass


func _split_polygon(clip_polygon: Array):
	"""
	Returns two polygons produced by vertically
	splitting split_polygon in half
	"""
	var avg_x = _avg_position(clip_polygon).x
	var left_subquadrant = default_quadrant_polygon.duplicate()
	left_subquadrant[1] = Vector2(avg_x, left_subquadrant[1].y)
	left_subquadrant[2] = Vector2(avg_x, left_subquadrant[2].y)
	var right_subquadrant = default_quadrant_polygon.duplicate()
	right_subquadrant[0] = Vector2(avg_x, right_subquadrant[0].y)
	right_subquadrant[3] = Vector2(avg_x, right_subquadrant[3].y)
	var pol1 = Geometry2D.clip_polygons(left_subquadrant, clip_polygon)[0]
	var pol2 = Geometry2D.clip_polygons(right_subquadrant, clip_polygon)[0]
	return [pol1, pol2]


func _is_hole(clipped_polygons):
	"""
	If either of the two polygons after clipping
	are clockwise, then you have carved a hole
	"""
	return Geometry2D.is_polygon_clockwise(clipped_polygons[0]) or Geometry2D.is_polygon_clockwise(clipped_polygons[1])


func _avg_position(array: Array):
	"""
	Average 2D position in an
	array of positions
	"""
	var sum = Vector2()
	for p in array:
		sum += p
	return sum/len(array)

func _new_pol(polygon):
	"""
	Returns Pol instance
	with assigned polygon
	"""
	var pol = Pol.instantiate()
	pol.polygon = polygon
	#pol.color = Color(Random.range_float(0, 1), Random.range_float(0, 1), Random.range_float(0, 1), 1)
	return pol
