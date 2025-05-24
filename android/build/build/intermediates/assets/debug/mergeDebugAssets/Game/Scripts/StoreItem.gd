extends Control

@export var price_label : Label
@export var buy_button : Button

var product_id : String
var tier : Enums.StoreTier
var price : float
var currency : String

func set_product_info(product_id : String, tier : Enums.StoreTier, price : float, currency : String):
	self.product_id = product_id
	self.tier = tier
	self.price = price
	self.currency = currency
	price_label.text = str(price) + " " + currency
	buy_button.connect("pressed", Callable(self, "_on_buy_button"))

func _on_buy_button():
	InAppPurchaseManager.purchase(self.product_id)
