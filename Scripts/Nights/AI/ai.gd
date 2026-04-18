@abstract
class_name AI
extends Node

enum State {ABSENT, PRESENT, ALT_1, ALT_2}

@export var camera: Camera

var ai_level: int
var step: int
var current_room: int

func has_passed_check() -> bool:
	return ai_level >= randi_range(1, 20)

func _is_room_empty(room: int) -> bool:
	return camera.rooms[room][0] == State.ABSENT

func move_check() -> void:
	if has_passed_check():
		move_options()

func move_options() -> void:
	pass

func move_to(target_room: int, new_state: int = State.PRESENT, move_step: int = 1) -> void:
	step += move_step
	
	camera.rooms[current_room][0] = State.ABSENT
	camera.rooms[target_room][0] = new_state
	
	camera.update_feeds([current_room, target_room])
	current_room = target_room
