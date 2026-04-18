extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_return_button_pressed() -> void:
	# Un-hide the mouse so the player can click the menu buttons!
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# IMPORTANT: Change this string to the exact file path of your Main Menu scene
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
