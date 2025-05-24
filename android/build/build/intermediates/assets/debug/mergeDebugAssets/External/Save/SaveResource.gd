extends Resource
class_name SaveResource

func get_save(name):
	for property in get_property_list():
		if property.name == name:
			return get(property.name)
	printerr("Save property not found")
	return null
