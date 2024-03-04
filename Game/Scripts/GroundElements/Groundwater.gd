extends GroundElement
class_name Groundwater

export(Material) var groundwater_material
export var content_texture : Texture

var material_instance

func _ready():
	#temporary
	material_instance = groundwater_material.duplicate()
	material_instance.set_shader_param('fill_percentage', 1.0)
	sprite.set_material(material_instance)

#Controller to recognize if there is a pump over it, if there is activate the pumping proccess
func _process(delta):
	if data.pumping:
		if data.fill_percentage > 0:
			data.fill_percentage -= data.pumping_rate * delta
			material_instance.set_shader_param('fill_percentage', data.fill_percentage)

func pump(pumping_percentage_rate : float):
	data.pumping_rate = pumping_percentage_rate
	data.pumping = true
	Events.emit_signal("on_start_pump", data.size)
