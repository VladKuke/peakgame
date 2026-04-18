extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_next_night_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
