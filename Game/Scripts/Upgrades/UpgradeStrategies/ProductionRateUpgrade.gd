extends UpgradeStrategy
class_name ProductionRateUpgrade

var increase_percentage

func _init(increase_percentage):
	self.increase_percentage = increase_percentage

func apply_upgrade(data):
	pass
