extends Control

@export var SC_label_path: NodePath
@export var HC_label_path: NodePath
@export var texture: Texture2D
@onready var SC_label : RichTextLabel = get_node(SC_label_path)
@onready var HC_label : RichTextLabel = get_node(HC_label_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set initial SC and HC
	_on_SC_changed(EconomyManager.player_data.SC)
	_on_HC_changed(EconomyManager.player_data.HC)
	#For future SC and HC changed
	Events.connect("on_SC_changed", Callable(self, "_on_SC_changed"))
	Events.connect("on_HC_changed", Callable(self, "_on_HC_changed"))

func _on_SC_changed(value) -> void:
	SC_label.text = value.to_str(2)
	
func _on_HC_changed(value) -> void:
	HC_label.text = value.to_str(0)
	
