extends Node2D

var done = false

func _process(delta):
	var texture = $SubViewport.get_texture()
	$MainCanvas/PlantManager/ScrollController/PlantScrollContainer/Control/Screen.texture = texture
