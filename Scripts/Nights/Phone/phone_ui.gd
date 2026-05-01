#extends Control
#
#const SCROLL_TICK: float = 30.0
#
#var can_scroll: bool = true
#var _last_scroll_y: float = 0.0
#var _accumulated: float = 0.0
#
#@onready var scroll_container: ScrollContainer = $ScrollContainer
#@onready var feed_vbox: VBoxContainer = $ScrollContainer/FeedVBox
#
#var post_scene: PackedScene = preload("res://Scenes/Feed/FeedPost.tscn")
#
#var calm_posts: Array[Dictionary] = [
	#{"user": "@morningvibes", "text": "coffee and a quiet morning ☕"},
	#{"user": "@softposting", "text": "reminder that you're doing okay"},
	#{"user": "@cozythreads", "text": "anyone else just stare at the ceiling for fun"},
	#{"user": "@dailydrift", "text": "today was actually not that bad"},
#]
#
#var stressed_posts: Array[Dictionary] = [
	#{"user": "@voidgazer", "text": "what if none of this matters"},
	#{"user": "@3am_thoughts", "text": "you ever just forget who you are for a second"},
	#{"user": "@lostinthefeed", "text": "the algorithm knows you better than you do"},
	#{"user": "@glitchghost_", "text": "s̷t̷a̷y̷ ̷o̷n̷l̷i̷n̷e̷"},
#]
#
#func _ready() -> void:
	#_populate_feed(calm_posts)
	#scroll_container.get_v_scroll_bar().value_changed.connect(_on_scrollbar_moved)
	#StressManager.stress_changed.connect(_on_stress_changed)
#
#func _on_scrollbar_moved(value: float) -> void:
	#if not can_scroll:
		#return
	#_accumulated += abs(value - _last_scroll_y)
	#_last_scroll_y = value
	#if _accumulated >= SCROLL_TICK:
		#_accumulated = 0.0
		#StressManager.register_scroll()
#
#func _process(_delta: float) -> void:
	#if not can_scroll:
		#return
	#var hovering = get_global_rect().has_point(get_global_mouse_position())
	#StressManager.set_feed_scrolling(hovering)
#
#func _on_stress_changed(value: float) -> void:
	#var ratio = value / StressManager.max_stress
	#if ratio > 0.6 and feed_vbox.get_child_count() < 10:
		#_add_stressed_posts()
#
#func set_can_scroll(value: bool) -> void:
	#can_scroll = value
	#modulate.a = 0.4 if not value else 1.0
	#if not value:
		#StressManager.set_feed_scrolling(false)
#
#func _populate_feed(posts: Array[Dictionary]) -> void:
	#for p in posts:
		#var post = post_scene.instantiate()
		#post.setup(p)
		#feed_vbox.add_child(post)
#
#func _add_stressed_posts() -> void:
	#stressed_posts.shuffle()
	#for p in stressed_posts:
		#var post = post_scene.instantiate()
		#post.setup(p)
		#feed_vbox.add_child(post)
