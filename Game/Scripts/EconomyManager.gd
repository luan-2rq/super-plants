extends CanvasLayer
class_name EconomyManager

var player_data : PlayerData

func _ready() -> void:
	player_data = PlayerData.new(BigNumber.new(0, 0), BigNumber.new(0, 0))

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

