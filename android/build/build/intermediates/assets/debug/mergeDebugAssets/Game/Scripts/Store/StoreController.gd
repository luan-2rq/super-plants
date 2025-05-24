extends Node
class_name StoreController

@export var open_button_path : NodePath
@export var close_button_path : NodePath
@onready var open_button : Button = get_node(open_button_path)
@onready var close_button : Button = get_node(close_button_path)

@export var store_config : StoreConfig
@export var store_item_scene : PackedScene

@export var special_packs_tier : Node
@export var SC_tier : Node
@export var HC_tier : Node

var store_items = []

func _ready():
	open_button.connect('pressed', Callable(self, '_on_open'))
	close_button.connect('pressed', Callable(self, '_on_close'))
	while not InAppPurchaseManager.is_ready():
		continue
	instantiate_store_items()

func _on_open():
	Events.emit_signal('open_screen', name)
	
func _on_close():
	Events.emit_signal('close_screen', name)

func instantiate_store_items():
	for product in store_config.products:
		#var product_info = InAppPurchaseManager.get_product_sku(product.id)
		#var price = product_info["price"]
		#var currency = product_info["currency"]
		var store_item = store_item_scene.instantiate()
		store_item.set_product_info(product.id, product.tier, 0.0, "BRL")
		match product.tier:
			Enums.StoreTier.SpecialPacks:
				special_packs_tier.add_child(store_item)
			Enums.StoreTier.HC:
				HC_tier.add_child(store_item)
			Enums.StoreTier.SC:
				SC_tier.add_child(store_item)
			_:
				printerr("%s product tier is unknow" % product.tier)
		store_items.append(store_item)
