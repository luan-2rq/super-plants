extends CanvasLayer
class_name EconomyManager

var player_data : PlayerData
var elapsed_time : float = 0

#In seconds
var yield_time : int = 1

func _ready() -> void:
	#To do: get playerdata from save manager
	player_data = PlayerData.new(BigNumber.new(0, 0), BigNumber.new(0, 0))

func _process(delta) -> void:
	pass
	#elapsed_time += delta
	#if elapsed_time > yield_time:
		#elapsed_time = 0
		#self.add_currency(Enums.CurrencyType.SC, player_data.SC_per_sec)
		
func add_currency(currency_name, amount):
	match currency_name:
		Enums.CurrencyType.HC:
			player_data.HC = BigNumber.sum(player_data.HC, amount)
			Events.emit_signal("on_HC_changed", player_data.HC)
		Enums.CurrencyType.SC:
			player_data.SC = BigNumber.sum(player_data.SC, amount)
			Events.emit_signal("on_SC_changed", player_data.SC)
		_:
			pass
			
func remove_currency(currency_name, amount):
	match currency_name:
		Enums.CurrencyType.HC:
			player_data.HC = BigNumber.subtract(player_data.HC, amount)
			Events.emit_signal("on_HC_changed", player_data.HC)
		Enums.CurrencyType.SC:
			player_data.SC = BigNumber.subtract(player_data.SC, amount)
			Events.emit_signal("on_SC_changed", player_data.SC)
		_:
			pass

