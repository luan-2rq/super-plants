extends CanvasLayer

var instance = null

var player_data : PlayerData
var elapsed_time : float = 0

#In seconds
var yield_time : int = 1

func _ready() -> void:
	# Ensure only one instance of the singleton exists
	if instance == null:
		instance = self
	else:
		# Destroy duplicate instances
		self.queue_free()
	#To do: get playerdata from save manager
	player_data = SaveManager.get_specific_save(Enums.SaveName.player_data)
	if player_data == null:
		player_data = PlayerData.new(BigNumber.new(2000, 3), BigNumber.new(0, 0))
		SaveManager.set_specific_save(Enums.SaveName.player_data, player_data)

func _process(delta) -> void:
	pass
	#elapsed_time += delta
	#if elapsed_time > yield_time:
		#elapsed_time = 0
		#self.add_currency(Enums.CurrencyType.SC, player_data.SC_per_sec)
		
func add_currency(currency_name, amount):
	match currency_name:
		Enums.CurrencyType.HC:
			player_data.HC.sum(amount)
			Events.emit_signal("on_HC_changed", player_data.HC)
		Enums.CurrencyType.SC:
			player_data.SC.sum(amount)
			Events.emit_signal("on_SC_changed", player_data.SC)
		_:
			push_error("Currency type passed is not valid.")
			pass
	
# Returns wheter there was enough currency to remove or not		
func remove_currency(currency_name, amount):
	match currency_name:
		Enums.CurrencyType.HC:
			if player_data.HC.greater_or_equal_than(amount):
				player_data.HC.subtract(amount)
				Events.emit_signal("on_HC_changed", player_data.HC)
				return true
			else:
				print("Not enough currency")
				return false
		Enums.CurrencyType.SC:	
			if player_data.SC.greater_or_equal_than(amount):
				player_data.SC.subtract(amount)
				Events.emit_signal("on_SC_changed", player_data.SC)
				return true
			else:
				print("Not enough currency")
				return false
		_:
			push_error("Currency type passed is not valid.")
			pass

