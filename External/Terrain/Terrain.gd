extends Node2D
class_name Terrain

export(int) var quadrant_size = 400
export(Vector2) var quadrant_grid_size = Vector2(2,10)

var quadrants_grid: Array = []

var Quadrant = preload("res://External/Terrain/Quadrant.tscn")
	
func _ready() -> void:
	init()

func init():
	for i in range(quadrant_grid_size.x):
		quadrants_grid.push_back([])
		for j in range(quadrant_grid_size.y):
			var quadrant = Quadrant.instance()
			quadrant.default_quadrant_polygon = [
				Vector2(quadrant_size*i,quadrant_size*j),
				Vector2(quadrant_size*(i+1),quadrant_size*j),
				Vector2(quadrant_size*(i+1),quadrant_size*(j+1)),
				Vector2(quadrant_size*i,quadrant_size*(j+1))
			]
			quadrants_grid[-1].push_back(quadrant)
			$Quadrants.add_child(quadrant)

func _make_circle(carve_radius):
	var nb_points = 15
	var pol = PoolVector2Array()
	for i in range(nb_points):
		var angle = lerp(-PI, PI, float(i)/nb_points)
		pol.append(Vector2(cos(angle), sin(angle)) * carve_radius)
	return pol

func carve(global_pos, carve_radius):
	var carve_polygon = Transform2D(0, global_pos - self.global_position).xform(_make_circle(carve_radius))
	var four_quadrants = _get_affected_quadrants(global_pos - self.global_position, carve_radius)
	for quadrant in four_quadrants:
		quadrant.carve(carve_polygon)

func add(global_pos, carve_radius):
	var carve_polygon = Transform2D(0, global_pos - self.global_position).xform(_make_circle(carve_radius))
	var four_quadrants = _get_affected_quadrants(global_pos - self.global_position, carve_radius)
	for quadrant in four_quadrants:
		quadrant.add(carve_polygon)

func _get_affected_quadrants(pos, carve_radius):
	"""
	Returns array of Quadrants that are affected by
	the carving. Not the best function: sometimes it
	returns some quadrants that are not affected
	"""
	var affected_quadrants = []
	var half_diag = sqrt(2)*quadrant_size/2
	for quadrant in $Quadrants.get_children():
		var quadrant_top_left = quadrant.default_quadrant_polygon[0]
		var quadrant_center = quadrant_top_left + Vector2(quadrant_size, quadrant_size)/2
		if quadrant_center.distance_to(pos) <= carve_radius + half_diag:
			affected_quadrants.push_back(quadrant)
	return affected_quadrants
