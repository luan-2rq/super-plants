extends Area2D
class_name Collectable

@export var floating_text_scene: PackedScene
@export var fill_sprite_path: NodePath
@export var collision_shape_path: NodePath
@export var fill_material: Material

@onready var fill_sprite = get_node(fill_sprite_path)
@onready var collision_shape = get_node(collision_shape_path)

var collectables_controller : CollectablesController
var data : CollectableData

var is_collectable : bool = false

func _ready():
	fill_sprite.material = fill_material.duplicate()
	connect("area_entered", Callable(self, "on_collision"))
	
func _physics_process(delta):
	fill_sprite.material.set_shader_parameter("fill_percentage", fill_sprite.material.get_shader_parameter("fill_percentage") + 0.05)
	if !is_collectable:
		self.global_position += Vector2(0, 1) * delta * 70
		if self.global_position.y > collectables_controller.ground.global_position.y:
			is_collectable = true
			var collectable_price = collectables_controller.collectables_config.initial_price*UpgradesManager.get_upgrade_value(Enums.UpgradeType.ProductValueUpgrade)
			collectables_controller.add_collectable(self.global_position, collectable_price, self)
	#EconomyManager.instance.add_currency(Enums.CurrencyType.SC, BigNumber.new(100, 0))
	#self.queue_free()

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.is_pressed():
			#if is_mouse_over(self.global_position - (fill_sprite.texture.get_size() * get_parent().scale/2), fill_sprite.texture.get_size() * get_parent().scale * 4):
	pass
				#self.collect()
	
func on_collision(area):
	if area.is_in_group("Ground"):
		if !is_collectable:
			pass
		
func _on_floating_text_anim_ended():
	self.queue_free()
	
func collect():
	EconomyManager.instance.add_currency(Enums.CurrencyType.SC, BigNumber.new(data.price, 0))
	var floating_text = floating_text_scene.instantiate()
	floating_text.z_index = 5
	floating_text.global_position = self.global_position
	get_tree().get_root().get_node("Main/MainCanvas").add_child(floating_text)
	floating_text.display_text(str(BigNumber.new(data.price, 0).to_str(0)), Color(0,1,0,1))
	floating_text.connect("anim_ended", Callable(self, "_on_floating_text_anim_ended"))
	self.visible = false
	
func is_mouse_over(global_position: Vector2, size: Vector2) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var rect = Rect2(global_position.x, global_position.y, size.x, size.y)
	return rect.has_point(mouse_position)
