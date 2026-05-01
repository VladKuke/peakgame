extends Node2D

const HOVER_FADE_DURATION: float = 0.3

@export var phone_ui: Control
@export var tablet_manager: Node2D
@export var office: Node2D # <--- Added this!

var is_phone_up: bool = false
var tweener: Tween

@onready var phone_button: TextureButton = $Phone_Button
@onready var phone_sprite: AnimatedSprite2D = $Phone_Sprite

func _ready() -> void:
	if phone_ui:
		phone_ui.visible = false
	phone_button.pressed.connect(_on_phone_button_click)
	phone_button.mouse_entered.connect(_on_phone_button_hover.bind(1.0))
	phone_button.mouse_exited.connect(_on_phone_button_hover.bind(0.5))
	phone_sprite.animation_finished.connect(_phone_animation_finished)

func _on_phone_button_click() -> void:
	if not is_phone_up:
		if tablet_manager and tablet_manager.is_tablet_up:
			return
		phone_sprite.visible = true
		phone_sprite.play("lift")
		
		# Stop looking around the office!
		if office:
			office.can_move = false 
	else:
		phone_sprite.play_backwards("lift")
		phone_button.disabled = true
		if phone_ui:
			phone_ui.visible = false
			
		# Resume looking around the office!
		if office:
			office.can_move = true

func _phone_animation_finished() -> void:
	if not is_phone_up:
		is_phone_up = true
		if phone_ui:
			phone_ui.visible = true
		StressManager.set_feed_scrolling(true)
	else:
		is_phone_up = false
		phone_sprite.visible = false
		phone_button.disabled = false
		StressManager.set_feed_scrolling(false)

func _on_phone_button_hover(alpha: float) -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(phone_button, "modulate:a", alpha, HOVER_FADE_DURATION)
