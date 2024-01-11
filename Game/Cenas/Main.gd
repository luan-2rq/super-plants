extends Node2D

func _process(delta):
	var texture = $Viewport.get_texture()
	$Main/PlantScrollContainer/Control/Screen.texture = texture
