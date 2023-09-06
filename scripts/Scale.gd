extends Node

@onready var root = get_window()
@onready var base_size = root.get_visible_rect().size

func _ready():
	
	if get_tree().root.connect("size_changed", _on_screen_resized) != OK:
		print_debug("An error occurred while connecting the screen_resized signal.")
	
	#root.set_attach_to_screen_rect(root.get_visible_rect())
	_on_screen_resized()

func _on_screen_resized():
	var new_window_size = DisplayServer.window_get_size()
	
	var scale_w = max(int(new_window_size.x / base_size.x), 1)
	var scale_h = max(int(new_window_size.y / base_size.y), 1)
	var scale = min(scale_w, scale_h)
	
	var diff = new_window_size - Vector2i(base_size * scale)
	var diffhalf = (diff * 0.5).floor()

	#root.set_attach_to_screen_rect(Rect2(diffhalf, base_size * scale))
	
	# Black bars to prevent flickering:
	var odd_offset = Vector2(int(new_window_size.x) % 2, int(new_window_size.y) % 2)
	
#	RenderingServer.black_bars_set_margins(
#		int(max(diffhalf.x, 0)), # prevent negative values, they make the black bars go in the wrong direction.
#		int(max(diffhalf.y, 0)),
#		int(max(diffhalf.x, 0)) + odd_offset.x,
#		int(max(diffhalf.y, 0)) + odd_offset.y
#	)

var old_window_mode

func _input(event):
	if event.is_action_released("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			old_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif old_window_mode:
			DisplayServer.window_set_mode(old_window_mode)
		else:
			old_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(old_window_mode)
