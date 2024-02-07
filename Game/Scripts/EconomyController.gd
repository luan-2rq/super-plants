extends CanvasLayer

var player_data : PlayerData
var added : bool

func _ready() -> void:
	player_data = PlayerData.new(BigNumber.new(0, 0), BigNumber.new(0, 0))

func _process(delta):
	if !added:
		add_currency(Enums.CurrencyType.HC, BigNumber.new(100, 2)) # 10000
		add_currency(Enums.CurrencyType.SC, BigNumber.new(200, 2)) # 20000
		added = true

func add_currency(currency_name, amount):
	match currency_name:
		Enums.CurrencyType.HC:
			print("starte")
			player_data.HC = BigNumber.sum(player_data.HC, amount)
			Events.emit_signal("on_HC_changed", player_data.HC)
		Enums.CurrencyType.SC:
			print("started")
			player_data.SC = BigNumber.sum(player_data.SC, amount)
			Events.emit_signal("on_SC_changed", player_data.SC)
		_:
			pass

