extends Node

var rng : = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
func range_int(start: int, end: int) -> int:
	return rng.randi_range(start, end)

func range_float(start: float, end: float) -> float:
	return rng.randf_range(start, end)
