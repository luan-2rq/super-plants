extends RayCast2D
class_name RayCast2DDraw

# Length of the ray
var ray_length : float = 200

func _draw():
	# Draw a line from the RayCast2D's global position to its cast_to point
	pass
	#draw_line(Vector2.ZERO, Vector2.ZERO + cast_to, Color(1, 0, 0))
