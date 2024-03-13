extends Control

@export var open_button_path : NodePath
@export var close_button_path : NodePath
@onready var open_button : Button = get_node(open_button_path)
@onready var close_button : Button = get_node(close_button_path)

@export var next_language_button_path : NodePath
@export var previous_language_button_path : NodePath
@onready var next_language_button : Button = get_node(next_language_button_path)
@onready var previous_language_button : Button = get_node(previous_language_button_path)

@export var current_language_label_path : NodePath
@onready var current_language_label : Label = get_node(current_language_label_path)

var settings_data
var locales = Enums.Languages.keys()

func _ready():
	settings_data = SaveManager.get_specific_save(Enums.SaveName.settings_data)
	if settings_data == null:
		settings_data = SettingsData.new()
		SaveManager.set_specific_save(Enums.SaveName.settings_data, settings_data)
		settings_data.locale = 0
	set_current_language_text(locales[settings_data.locale])
	open_button.connect('pressed', Callable(self, '_on_open'))
	close_button.connect('pressed', Callable(self, '_on_close'))
	next_language_button.connect('pressed', Callable(self, '_on_language_forward'))
	previous_language_button.connect('pressed', Callable(self, '_on_language_backward'))

func _on_open():
	Events.emit_signal('open_popup', name)
	
func _on_close():
	Events.emit_signal('close_popup', name)

func _on_language_forward():
	settings_data.locale = (settings_data.locale + 1) % locales.size()
	var next_locale = locales[settings_data.locale]
	TranslationServer.set_locale(next_locale)
	set_current_language_text(next_locale)
	
func _on_language_backward():
	settings_data.locale = (settings_data.locale - 1) % locales.size()
	var past_locale = locales[settings_data.locale]
	TranslationServer.set_locale(past_locale)
	set_current_language_text(past_locale)
	
func set_current_language_text(locale):
	current_language_label.text = Enums.Languages[locale]

