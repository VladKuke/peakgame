extends Control

var can_scroll: bool = true

func _ready() -> void:
	pass # No more videos to load!

func _process(_delta: float) -> void:
	if not can_scroll or not visible:
		StressManager.set_feed_scrolling(false)
		return
	
	# Tells the StressManager to lower stress when the mouse is over the phone
	var hovering = get_global_rect().has_point(get_global_mouse_position())
	StressManager.set_feed_scrolling(hovering)

func set_can_scroll(value: bool) -> void:
	can_scroll = value
	if not value:
		StressManager.set_feed_scrolling(false)
