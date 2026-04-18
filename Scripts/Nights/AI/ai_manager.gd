extends Node

@export_range(0, 20) var sahur_level: int

func _ready() -> void:
	randomize()
	_initialize_char_levels()

func _initialize_char_levels() -> void:
	$Sahur.ai_level = sahur_level
