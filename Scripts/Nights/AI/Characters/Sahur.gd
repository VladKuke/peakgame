extends AI

enum {ROOM_01, ROOM_02, ROOM_03, ROOM_04, ROOM_05, DOOR_LEFT, DOOR_RIGHT}

var aggression: int = 0

func _ready() -> void:
	call_deferred("_spawn_sahur")

func _spawn_sahur() -> void:
	current_room = ROOM_01
	step = 0
	aggression = 0
	if camera:
		camera.rooms[ROOM_01][0] = State.PRESENT
		camera.update_feeds([ROOM_01])

func move_options() -> void:
	aggression += 1
	
	match current_room:
		ROOM_01:
			if randi() % 2 == 0:
				move_to(ROOM_05)
			else:
				move_to(ROOM_03)
				
		ROOM_05:
			if aggression >= 4 or randi() % 100 < 65:
				move_to(ROOM_02)
			else:
				move_to(ROOM_01, State.PRESENT, -step)
				
		ROOM_02:
			if aggression >= 5 or randi() % 100 < 75:
				jump_to_door(DOOR_LEFT)
			else:
				move_to(ROOM_05, State.PRESENT, -1)
				
		ROOM_03:
			if aggression >= 4 or randi() % 100 < 65:
				move_to(ROOM_04)
			else:
				move_to(ROOM_01, State.PRESENT, -step)
				
		ROOM_04:
			if aggression >= 5 or randi() % 100 < 75:
				jump_to_door(DOOR_RIGHT)
			else:
				move_to(ROOM_03, State.PRESENT, -1)

func jump_to_door(door_side: int) -> void:
	if camera:
		camera.rooms[current_room][0] = State.ABSENT
		camera.update_feeds([current_room])
	current_room = door_side
	aggression = 0

func reset_to_stage() -> void:
	current_room = ROOM_01
	step = 0
	aggression = 0
	if camera:
		camera.rooms[ROOM_01][0] = State.PRESENT
		camera.update_feeds([ROOM_01])
