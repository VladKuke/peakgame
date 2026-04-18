extends Camera

enum {ROOM_01, ROOM_02, ROOM_03, ROOM_04, ROOM_05}

func set_feed(feed_to_update: int) -> void:
	var room_state: int = rooms[feed_to_update][0]
	var room_feed: Sprite2D = all_feeds[feed_to_update]
	
	match feed_to_update:
		ROOM_01, ROOM_02, ROOM_03, ROOM_04, ROOM_05:
			if room_state == 0:
				room_feed.frame = 0
			else:
				room_feed.frame = 1


func _on_room_5_pressed() -> void:
	pass # Replace with function body.
