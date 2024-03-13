@tool
extends EditorPlugin

const main_panel = preload("res://addons/SheetsLocalizationImporter/LocalizationImporter.tscn")
var main_panel_instance

func _enter_tree():
	main_panel_instance = main_panel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)
	
func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()
	
func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible
	
func _has_main_screen():
	return true
	
func _get_plugin_name():
	return "Localization Sheet Importer"
	
func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
