extends Area2D
class_name GroundElement

onready var terrain = $"../../Terrain"
onready var sprite : Sprite = $Sprite
onready var collision_polygon_2d : CollisionPolygon2D = $CollisionPolygon2D

var data : GroundElementData
var arrows : Array

func _ready():
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
	
func reveal():
	#Fix to use current groundelement radius
	var quadrants = terrain.carve(self.global_position, 100)
	#Remove arrows
	for arrow in arrows:
		arrow.get_parent().remove_child(arrow)
	arrows.clear()

func add_arrow(arrow, arrow_data):
	arrows.append(arrow)
	data.arrows.append(arrow_data)

func overlaps(area_2d):
	return overlaps_area(area_2d)

