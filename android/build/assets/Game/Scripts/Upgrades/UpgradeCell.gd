extends Node
class_name UpgradeCell

@export var upgrade_title_path : NodePath
@export var upgrade_description_path : NodePath
@export var upgraded_times_text_path : NodePath
@export var upgrade_button_path : NodePath
@export var price_text_path : NodePath

@onready var upgrade_title_text : Label = get_node(upgrade_title_path)
@onready var upgrade_description_text : Label = get_node(upgrade_description_path)
@onready var upgraded_times_text : Label = get_node(upgraded_times_text_path)
@onready var price_text : Label
@onready var upgrade_button : Button = get_node(upgrade_button_path)

var config : UpgradeConfig
var data : UpgradeData

func _ready() -> void:
	pass
	#upgrade_button.connect("pressed", self, "_on_upgrade_button_pressed")
	#self.upgrade_title_text.text = config.title_locale_key
	#self.upgrade_description_text.text = config.description_locale_key
	#self.upgraded_times_text.text = "0x"

func _on_upgrade_button_pressed():
	data.upgraded_times += 1
	Events.emit_signal("on_upgrade", config.upgrade_type)
