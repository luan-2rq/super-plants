extends Node

export var upgrades_config : Resource
var upgrades_data : Resource

func _ready():
	upgrades_data = SaveManager.get_specific_save(Enums.SaveName.upgrades_data)
	if upgrades_data == null:
		upgrades_data = UpgradesData.new()
		for upgrade_config in upgrades_config.upgrades:
			var upgrade_data = UpgradeData.new()
			upgrades_data.upgrades.append(upgrade_data)
	else:
		if upgrades_data.upgrades.size() < upgrades_config.upgrades.size():
			for i in range(upgrades_data.upgrades.size()-1, upgrades_config.upgrades.size()-1):
				var upgrade_data = UpgradeData.new()
				upgrades_data.upgrades.append(upgrade_data)
	SaveManager.set_specific_save(Enums.SaveName.upgrades_data, upgrades_data)

func get_upgrade_value(upgrade_type) -> float:
	var upgrade_value : float
	for i in range(upgrades_config.upgrades.size()):
		if upgrades_config.upgrades[i].upgrade_type == upgrade_type:
			if upgrade_value == 0:
				if upgrades_config.upgrades[i].increase:
					upgrade_value = pow(1+upgrades_config.upgrades[i].percentage_factor, upgrades_data.upgrades[i].upgraded_times)
				else:
					upgrade_value = pow(1+upgrades_config.upgrades[i].percentage_factor, upgrades_data.upgrades[i].upgraded_times)
			else:
				if upgrades_config.upgrades[i].increase:
					upgrade_value *= pow(1+upgrades_config.upgrades[i].percentage_factor, upgrades_data.upgrades[i].upgraded_times)
				else:
					upgrade_value /= pow(1+upgrades_config.upgrades[i].percentage_factor, upgrades_data.upgrades[i].upgraded_times)
	return upgrade_value
