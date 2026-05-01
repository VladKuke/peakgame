extends ProgressBar

func _ready() -> void:
	StressManager.stress_changed.connect(_on_stress_changed)
	value = StressManager.current_stress
	max_value = StressManager.max_stress

func _on_stress_changed(new_stress: float) -> void:
	value = new_stress
