extends GroundElement
class_name Groundwater

@export var groundwater_material: Material
@export var content_texture : Texture2D

var material_instance

func _ready():
	#temporary
	material_instance = groundwater_material.duplicate()
	material_instance.set_shader_parameter('fill_percentage', data.fill_percentage)
	sprite.set_material(material_instance)

#Controller to recognize if there is a pump over it, if there is activate the pumping proccess
func _process(delta):
	if data.pumping:
		if data.fill_percentage > 0:
			data.remaining_water -= data.pumping_velocity * delta
			data.fill_percentage = data.remaining_water / data.size
			material_instance.set_shader_parameter('fill_percentage', data.fill_percentage)
		else:
			data.pumping = false
			Events.emit_signal("on_emptied_groundwater", self)

func pump(pumping_percentage_rate : float):
	data.pumping_velocity = pumping_percentage_rate
	data.pumping = true
	Events.emit_signal("on_start_pump", data.size)
