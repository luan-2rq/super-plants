extends Node2D
class_name Terrain

onready var screen_size = get_viewport().size

export(bool) var collision
onready var carve_area_size = screen_size

var quadrants_grid: Array = []

onready var carve_area = $CarveArea
var Quadrant = preload("res://External/TerrainDestruction/Prefabs/Quadrant.tscn")
var Rigid = preload("res://External/TerrainDestruction/Prefabs/RigidBody.tscn")

var polygon

func _ready():
	_generate_carve_area()

func _generate_carve_area():
	carve_area.polygon = [
		Vector2(0,0),
		Vector2(carve_area_size.x,0),
		Vector2(carve_area_size.x,carve_area_size.y),
		Vector2(0,carve_area_size.y)
	]

func _make_circle_polygon(pos, radius):
	var nb_points = 15
	var pol = []
	for i in range(nb_points):
		var angle = lerp(-PI, PI, float(i)/nb_points)
		pol.push_back(pos + Vector2(cos(angle), sin(angle)) * radius)
	return pol

func carve(pos, radius):
	var carve_polygon = PoolVector2Array()
	if polygon == null:
		carve_polygon = _make_circle_polygon(Vector2(0, 0), radius)
		polygon = carve_polygon
	else:
		for point in polygon:
			carve_polygon.append(point+pos)
	print("Carved polygon: " + str(Geometry.clip_polygons_2d(carve_area.polygon, carve_polygon)))
	carve_area.set_deferred("polygon", Geometry.clip_polygons_2d(carve_area.polygon, carve_polygon)[0])

func add(pos, radius):
	var add_polygon
	if polygon == null:
		add_polygon = _make_circle_polygon(Vector2(0, 0), radius)
		polygon = add_polygon
	else:
		add_polygon = Transform2D(0, pos).xform(polygon)
	carve_area.polygon = Geometry.clip_polygons_2d(carve_area.polygon, add_polygon)
