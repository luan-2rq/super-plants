extends Position2D
class_name FloatingText

export(NodePath) var label_path
export(NodePath) var tween_path
onready var label = get_node(label_path)
onready var tween  : Tween = get_node(tween_path)

signal anim_ended

func display_text(text, color, delay = 0):
	label.set_text(text)
	label.modulate = color
	self.visible = false
	yield(get_tree().create_timer(delay), "timeout")
	self.visible = true
	tween.interpolate_property(self, 'position', self.position, self.position + Vector2.UP * 100, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")

func _on_tween_all_completed():
	self.emit_signal("anim_ended")
	self.queue_free()
