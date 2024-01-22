extends Node
class_name UpgradeCell

var upgrade_title_path : NodePath
var upgrade_description_path : NodePath
var upgraded_times_text_path : NodePath

onready var upgrade_title_text : RichTextLabel = get_node(upgrade_title_path)
onready var upgrade_description_text : RichTextLabel = get_node(upgrade_description_path)
onready var upgraded_times_text : RichTextLabel = get_node(upgraded_times_text_path)

var upgrade_max_times : int

func _init(upgrade_title : String, upgrade_description : String , upgrade_max_times : int):
	pass
	#self.upgrade_title_text.bbcode_text = upgrade_title
	#self.upgrade_description_text.bbcode_text = upgrade_description
	#self.upgrade_max_times = upgrade_max_times
