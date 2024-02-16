extends Area2D
class_name GroundElement

onready var sprite : Sprite = $Sprite
onready var collision_polygon_2d : CollisionPolygon2D = $CollisionPolygon2D

func _ready():
	pass
	var polys = sprite_to_polygon()
	collision_polygon_2d.polygon = Transform2D(0, Vector2(-sprite.texture.get_size().x/2, -sprite.texture.get_size().y/2)).xform(polys[0])
	
func sprite_to_polygon():
	var data = sprite.texture.get_data()
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	
	var polys = bitmap.opaque_to_polygons(
		Rect2(
		   Vector2.ZERO, 
		   sprite.texture.get_size()
		  ),
		  5
		)
	return polys

func overlaps(area_2d):
	return overlaps_area(area_2d)
