extends KinematicBody2D
class_name Collectable

var position_on_branch

export(PackedScene) var floating_text_scene

export(NodePath) var fill_sprite_path
export(NodePath) var collision_shape_path
export(Material) var fill_material
onready var fill_sprite = get_node(fill_sprite_path)
onready var collision_shape = get_node(collision_shape_path)

var consumed : bool

func _ready():
	fill_sprite.material = fill_material.duplicate()
	set_deferred("gravity_scale", 0)
	
func _physics_process(delta):
	fill_sprite.material.set_shader_param("fill_percentage", fill_sprite.material.get_shader_param("fill_percentage") + 0.05)
	if !consumed:
		var collided = move_and_collide(Vector2(0, 1))
		if collided:
			consumed = true
			#EconomyManager.instance.add_currency(Enums.CurrencyType.SC, BigNumber.new(100, 0))
			#self.queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if is_mouse_over(global_position - (fill_sprite.texture.get_size() * collision_shape.scale/2), fill_sprite.texture.get_size() * collision_shape.scale * 4):
				EconomyManager.instance.add_currency(Enums.CurrencyType.SC, BigNumber.new(100, 0))
				var floating_text = floating_text_scene.instance()
				floating_text.z_index = 5
				floating_text.global_position = self.global_position
				get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
				floating_text.display_text(str(BigNumber.new(100, 0).to_string()), Color(0,1,0,1))
				floating_text.connect("anim_ended", self, "_on_floating_text_anim_ended")
				self.visible = false
	
func _on_floating_text_anim_ended():
	self.queue_free()
	
func is_mouse_over(rect_global_position: Vector2, rect_size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(rect_global_position.x, rect_global_position.y, rect_size.x, rect_size.y)
	return rect.has_point(mouse_position)
