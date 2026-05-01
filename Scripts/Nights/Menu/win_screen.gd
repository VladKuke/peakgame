extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_next_night_button_pressed() -> void:
	# Unpause the game before reloading!
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_return_button_pressed() -> void:
	# Unpause the game before changing scenes!
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
