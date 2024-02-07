extends Control

export(NodePath) var SC_label_path
export(NodePath) var HC_label_path
export(Texture) var texture
onready var SC_label : RichTextLabel = get_node(SC_label_path)
onready var HC_label : RichTextLabel = get_node(HC_label_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("on_SC_changed", self, "_on_SC_changed")
	Events.connect("on_HC_changed", self, "_on_HC_changed")

func _on_SC_changed(value) -> void:
	SC_label.bbcode_text = value.to_string()
	
func _on_HC_changed(value) -> void:
	HC_label.bbcode_text = value.to_string()
	
