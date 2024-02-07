extends Node2D
class_name UpgradeManager

var upgrade_strategy : UpgradeStrategy

func _init(strategy: UpgradeStrategy):
		upgrade_strategy = strategy

func apply_upgrade(data):
	return upgrade_strategy.apply_upgrade(data)
