extends Control

var blink_tween: Tween

func _ready():
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			btn.mouse_entered.connect(btn.grab_focus)
			btn.focus_entered.connect(_on_hover.bind(btn))
			
			btn.focus_neighbor_left = btn.get_path() 
			btn.focus_neighbor_right = btn.get_path() 

	if Global.has_save == true:
		$VBoxContainer/Continue.modulate.a = 1.0 
		$VBoxContainer/Continue.disabled = false 
		$VBoxContainer/Continue.grab_focus() 
	else:
		$VBoxContainer/Continue.modulate.a = 0.0 
		$VBoxContainer/Continue.disabled = true  
		$"VBoxContainer/New Game".grab_focus()

func _input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 

func _process(delta: float) -> void:
	pass

func _on_play_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/Nights/nights.tscn")

func _on_new_game_pressed():
	Global.current_night = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/Nights/nights.tscn")

func _on_quit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().quit()

func _on_hover(btn: Button):
	for b in $VBoxContainer.get_children():
		if b is Button and b.has_node("Arrow"):
			b.get_node("Arrow").hide()
			
	if btn.has_node("Arrow"):
		var arrow = btn.get_node("Arrow")
		
		if blink_tween:
			blink_tween.kill()
			
		arrow.show() 
		arrow.modulate.a = 1.0 
		
		blink_tween = create_tween().set_loops()
		blink_tween.tween_interval(0.3) 
		blink_tween.tween_property(arrow, "modulate:a", 0.0, 0.0) 
		blink_tween.tween_interval(0.3) 
		blink_tween.tween_property(arrow, "modulate:a", 1.0, 0.0)

func _on_unhover(btn: Button):
	if btn.has_node("Arrow"):
		var arrow = btn.get_node("Arrow")
		arrow.hide()
		
		if blink_tween:
			blink_tween.kill()
