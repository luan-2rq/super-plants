extends Node2D

var raycast : RayCast2D
var line : Line2D

#func _ready():
   # Create a RayCast2D node
	#raycast = RayCast2D.new()
	#add_child(raycast)
	#raycast.collide_with_areas = true
	#raycast.enabled = true

	# Create a Line2D node for visualization
	#line = Line2D.new()
	#add_child(line)
	# Connect the mouse motion signal to the _process_mouse_motion function
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set_process(true)

#func _process(delta):
	# Update the position of the RayCast2D to follow the mouse
	#var mouse_pos = get_global_mouse_position()
	#raycast.global_position = Vector2.ZERO
	#raycast.cast_to = to_local(mouse_pos)

	# Perform a raycast and update the Line2D
	#var is_colliding = raycast.is_colliding()
	#if is_colliding:
		#var collision_point = raycast.get_collision_point()
		#line.points = [Vector2(0, 0), collision_point]
	#else:
		#line.points = [Vector2(0, 0), mouse_pos]
		
#func _input(event):
	#if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		# Print the collision information when the left mouse button is pressed
		#print("Collision Point:", raycast.get_collision_point())
		#print("Collision Normal:", raycast.get_collision_normal())
#DIVISOR

func _draw():
	pass
	#draw_line(Vector2(-400, 400), Vector2(2000, 400), Color(0, 0, 0))
	#draw_line(Vector2(240, 250), Vector2(240, 1000), Color(0, 0, 0))

