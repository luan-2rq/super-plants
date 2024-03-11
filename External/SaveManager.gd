extends Node

const SAVE_PATH := "user://save_game.tres"
onready var save_resource

var elapsed_time : float = 0
var save_rate = 2

func _ready():
	if save_exists():
		load_save()
	else:
		save_resource = Save.new()

func save_game():
	ResourceSaver.save(SAVE_PATH, save_resource)

func _process(delta):
	elapsed_time += delta
	if elapsed_time > save_rate:
		save_game()
		elapsed_time = 0

func load_save():
	save_resource = Save.new()
	save_resource = load(SAVE_PATH) as Save

func get_specific_save(save_enum): 
	return save_resource.get(str(Enums.SaveName.keys()[save_enum]))

func set_specific_save(save_enum, save): 
	save_resource.set(str(Enums.SaveName.keys()[save_enum]), save)

func save_exists():
	var file = File.new()
	var exists = file.file_exists(SAVE_PATH)
	file.close()
	return exists
