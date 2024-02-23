extends GroundElement
class_name Groundwater

export(Material) var groundwater_material
export var content_texture : Texture

var config : GroundwaterConfig
var groundwater_data : GroundwaterData
var material_instance

func _ready():
	#temporary
	groundwater_data = GroundwaterData.new()
	material_instance = groundwater_material.duplicate()
	material_instance.set_shader_param('fill_percentage', 1.0)
	sprite.set_material(material_instance)

#Controller to recognize if there is a pump over it, if there is activate the pumping proccess
func _process(delta):
	if groundwater_data.pumping:
		if groundwater_data.fill_percentage > 0:
			groundwater_data.fill_percentage -= groundwater_data.pumping_rate * delta
			material_instance.set_shader_param('fill_percentage', groundwater_data.fill_percentage)

func pump(pumping_percentage_rate : float):
	groundwater_data.pumping_rate = pumping_percentage_rate
	groundwater_data.pumping = true
	Events.emit_signal("on_start_pump", config.size)
