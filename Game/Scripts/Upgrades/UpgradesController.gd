extends Control
class_name UpgradesController

export var expandable_cells_controller_path : NodePath
onready var expandable_cells_controller = get_node(expandable_cells_controller_path)

export var upgrades_config : Resource
var upgrades_data

export(PackedScene) var upgrade_cell

func _ready():
	upgrades_data = SaveManager.get_specific_save(Enums.SaveName.upgrades_data)
	expandable_cells_controller.initialize(20,upgrade_cell,upgrades_config.upgrades.size())
