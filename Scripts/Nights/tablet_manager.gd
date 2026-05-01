extends Node2D

const HOVER_FADE_DURATION: float = 0.3

@export_group("Setup")
@export var camera: Camera
@export var office: Node2D

var is_tablet_up: bool = false
var tweener: Tween

@onready var tablet_button: TextureButton = $Tablet_Button
@onready var tablet_sprite: AnimatedSprite2D = $Tablet_Sprite

func _ready() -> void:
	# Force the connection in code so it never breaks!
	tablet_sprite.animation_finished.connect(_tablet_animation_finished)

func _on_tablet_button_click() -> void:
	if StressManager.is_feed_scrolling: return
	
	if not is_tablet_up:
		tablet_sprite.play("lift_1")
		tablet_sprite.visible = true
		if office:
			office.can_move = false
			office.force_lights_off()
		StressManager.set_cameras_open(true)
	else:
		tablet_sprite.play_backwards("lift_1") # <-- Changed to lift_1 here!
		tablet_button.disabled = true
		if camera:
			camera.visible = false
		StressManager.set_cameras_open(false)

func _tablet_animation_finished() -> void:
	if not is_tablet_up:
		is_tablet_up = true
		if camera:
			camera.visible = true
			camera.play_static()
	else:
		is_tablet_up = false
		tablet_sprite.visible = false
		if office:
			office.can_move = true
		tablet_button.disabled = false

func _on_tablet_button_hover(alpha: float) -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(tablet_button, "modulate:a", alpha, HOVER_FADE_DURATION)
