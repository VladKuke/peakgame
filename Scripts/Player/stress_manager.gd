extends Node

signal stress_changed(value: float)
signal stress_maxed

@export var max_stress: float = 100.0
@export var idle_rate: float = 7.0
@export var decay_rate: float = 15.0

var current_stress: float = 0.0
var is_feed_scrolling: bool = false
var cameras_open: bool = false

func _process(delta: float) -> void:
	if is_feed_scrolling and not cameras_open:
		current_stress = max(0.0, current_stress - decay_rate * delta)
	else:
		current_stress = min(max_stress, current_stress + idle_rate * delta)
	
	stress_changed.emit(current_stress)
	if current_stress >= max_stress:
		stress_maxed.emit()

func set_cameras_open(open: bool) -> void:
	cameras_open = open

func set_feed_scrolling(scrolling: bool) -> void:
	is_feed_scrolling = scrolling

func get_stress_ratio() -> float:
	return current_stress / max_stress
