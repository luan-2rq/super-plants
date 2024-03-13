extends Node

var payment
var skus = {} # Dictionary to store SKUs

func _ready() -> void:
	if OS.get_name() == "Android":
		if Engine.has_singleton("GodotGooglePlayBilling"):
			payment = Engine.get_singleton("GodotGooglePlayBilling")
			payment.connect("connected", Callable(self, "_on_connected"))
		else:
			print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
	elif OS.get_name() == "iOS":
		if Engine.has_singleton("InAppStore"):
			payment = Engine.get_singleton("InAppStore")
			payment.connect("product_info_received", Callable(self, "_on_ios_product_info_received"))
		else:
			print("IOS IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
	else:
		print("Platform not supported for IAPs")

func _on_connected():
	pass

func _on_sku_details_query_completed(sku_details: Array) -> void:
	for sku in sku_details:
		skus[sku["productId"]] = sku

func _on_ios_product_info_received(product_id: String, title: String, description: String, price: String, locale: String, currency: String) -> void:
	skus[product_id] = {"productId": product_id, "title": title, "description": description, "price": price, "locale": locale, "currency": currency}

func get_sku_by_id(id: String) -> Dictionary:
	if id in skus:
		return skus[id]
	else:
		return {}

func is_ready():
	if OS.get_name() == "Android":
		return payment.isReady()
	elif OS.get_name() == "iOS":
		pass
	else:
		pass
