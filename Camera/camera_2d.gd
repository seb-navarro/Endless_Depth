extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setting camera limits and positioning player slightly above the center.
	limit_left = 0
	limit_right = Global.screen_width
	offset.y = 0.15 * Global.screen_height


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
	
