extends Node

var payment

func _ready() -> void:
	if OS.get_name() == "Android":
		if Engine.has_singleton("GodotGooglePlayBilling"):
			payment = Engine.get_singleton("GodotGooglePlayBilling")
			payment.connect("connected", Callable(self, "_on_android_connected"))
			payment.connect("purchase_acknowledged", Callable(self, "_on_purchase_acknowledged"))
			payment.connect("purchase_consumed", Callable(self, "_on_purchase_consumed"))
			payment.connect("connect_error", Callable(self, "_on_connect_error"))
			payment.startConnection()
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

func _on_purchase_acknowledged(token):
	print("Purchase was acknowledged" + "\n" + token)

func _on_purchase_consumed(token):
	print("Purchase was consumed" + "\n" + token)

func _on_connect_error():
	pass
	
func is_ready():
	if OS.get_name() == "Android":
		return payment.isReady()
	elif OS.get_name() == "iOS":
		pass
	else:
		return true

#For a purchase to be sucessful this function needs to be called before at any moment
func get_product_sku(product_id):
	if OS.get_name() == "Android":
		var product_info = payment.get_product_info(product_id)
		return {
			"price": product_info["price"],
			"currency": product_info["currency"]
  	  }
	elif OS.get_name() == "iOS":
		pass
	else:
		pass

func purchase(product_id):
	if OS.get_name() == "Android":
		var response = payment.purchase(product_id)
		if response != OK:
			printerr("Not able to purchase due to error: %s" % response)
	elif OS.get_name() == "iOS":
		pass
	else:
		pass
