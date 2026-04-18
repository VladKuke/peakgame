extends Sprite2D

const SCROLL_SMOOTHING: int = 12
const SCROLL_SPEED: float = 0.07
const SCROLL_SCREEN_FRACTION: float = 3

@export var scroll_clamp: int = 650

@export_group("Sahur Doorway Connections")
@export var sahur_node: Node 
@export var sahur_left_sprite: Sprite2D 
@export var sahur_right_sprite: Sprite2D 

@export_group("Flashlights")
@export var left_light: PointLight2D
@export var right_light: PointLight2D

@export_group("UI Management")
@export var game_over_menu: CanvasLayer
@export var win_screen_menu: CanvasLayer
@export var tablet_system: Node2D
@export var time_label: Label

var left_light_timer: float = 0.0
var right_light_timer: float = 0.0
const TIME_TO_REPEL: float = 3.0

var death_timer: float = 0.0
const TIME_TO_DIE: float = 5.0

var real_time_timer: float = 0.0
var current_hour: int = 0
const SECONDS_PER_HOUR: float = 30.0

var scroll_area_left: float
var scroll_area_right: float
var scroll_amount: float = 0
var can_move: bool = true

func _ready() -> void:
	_initialize_scroll_areas(get_viewport())
	_update_time_display()

func _process(delta: float) -> void:
	_handle_move(delta)
	_handle_doorway_mechanics(delta)
	_handle_time(delta)

func _initialize_scroll_areas(viewport: Viewport) -> void:
	var view_size_x: float = viewport.content_scale_size.x
	var scroll_area_offset: float = 1 / (viewport.size.x / view_size_x)
	var scroll_area_size: float = view_size_x / SCROLL_SCREEN_FRACTION
	scroll_area_left = scroll_area_size
	scroll_area_right = view_size_x - (scroll_area_size + scroll_area_offset)

func _handle_move(delta: float) -> void:
	if can_move:
		var mouse_position: Vector2 = get_global_mouse_position()
		if mouse_position.x < scroll_area_left:
			scroll_amount += (scroll_area_left - mouse_position.x) * SCROLL_SPEED
		elif mouse_position.x > scroll_area_right:
			scroll_amount += (scroll_area_right - mouse_position.x) * SCROLL_SPEED
	
	scroll_amount = clamp(scroll_amount, -scroll_clamp, scroll_clamp)
	position.x = lerp(position.x, scroll_amount, SCROLL_SMOOTHING * delta)

func _handle_doorway_mechanics(delta: float) -> void:
	if not sahur_node: return
	
	# 1. Left Door Logic
	if sahur_node.current_room == sahur_node.DOOR_LEFT: 
		if left_light and left_light.enabled:
			sahur_left_sprite.visible = true
			left_light_timer += delta
			# Death timer is NOT increasing here! The light stops him.
			
			if left_light_timer >= TIME_TO_REPEL:
				_repel_sahur()
		else:
			sahur_left_sprite.visible = false
			left_light_timer = 0.0
			
			# Light is off, so he gets impatient!
			death_timer += delta 
			if death_timer >= TIME_TO_DIE:
				_game_over()
			
	# 2. Right Door Logic
	elif sahur_node.current_room == sahur_node.DOOR_RIGHT:
		if right_light and right_light.enabled:
			sahur_right_sprite.visible = true
			right_light_timer += delta
			
			if right_light_timer >= TIME_TO_REPEL:
				_repel_sahur()
		else:
			sahur_right_sprite.visible = false
			right_light_timer = 0.0
			
			# Light is off, so he gets impatient!
			death_timer += delta 
			if death_timer >= TIME_TO_DIE:
				_game_over()
			
	# 3. Reset if he leaves
	else:
		sahur_left_sprite.visible = false
		sahur_right_sprite.visible = false
		left_light_timer = 0.0
		right_light_timer = 0.0
		death_timer = 0.0

func _handle_time(delta: float) -> void:
	real_time_timer += delta
	if real_time_timer >= SECONDS_PER_HOUR:
		real_time_timer = 0.0
		current_hour += 1
		_update_time_display()
		
		if current_hour >= 6:
			_win_game()

func _update_time_display() -> void:
	if not time_label: return
	if current_hour == 0:
		time_label.text = "12 AM"
	else:
		time_label.text = str(current_hour) + " AM"

func _repel_sahur() -> void:
	left_light_timer = 0.0
	right_light_timer = 0.0
	death_timer = 0.0
	sahur_node.reset_to_stage()

func _game_over() -> void:
	set_process(false)
	can_move = false
	force_lights_off()
	if tablet_system:
		tablet_system.visible = false
	if game_over_menu:
		game_over_menu.visible = true

func _win_game() -> void:
	set_process(false)
	can_move = false
	force_lights_off()
	if tablet_system:
		tablet_system.visible = false
	if win_screen_menu:
		win_screen_menu.visible = true

func force_lights_off() -> void:
	if left_light: left_light.enabled = false
	if right_light: right_light.enabled = false

func _on_left_door_button_button_down() -> void:
	if can_move and left_light: 
		left_light.enabled = true

func _on_left_door_button_button_up() -> void:
	if left_light: left_light.enabled = false

func _on_right_door_button_button_down() -> void:
	if can_move and right_light: 
		right_light.enabled = true

func _on_right_door_button_button_up() -> void:
	if right_light: right_light.enabled = false
