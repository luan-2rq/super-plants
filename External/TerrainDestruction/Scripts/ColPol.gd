extends CollisionPolygon2D
class_name ColPol

func _ready():
	$Polygon2D.polygon = polygon
	add_to_group("Terrain")

func update_pol(polygon_points):
	polygon = polygon_points
	$Polygon2D.polygon = polygon
