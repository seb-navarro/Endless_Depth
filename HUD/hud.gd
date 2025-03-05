extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Message.hide()
	$PersonalBest.hide()
	$DepthReached.hide()
	$DepthReachedValue.hide()
	$MetersReached.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_message(text, time, colour):
	$Message.text = text
	$Message.add_theme_color_override("font_color", Color(colour))
	$Message.show()
	$MessageTimer.wait_time = time
	$MessageTimer.start()
	
func show_game_over():
	show_message("GAME OVER", 10, "ea4800")
	$DepthReached.show()
	$DepthReachedValue.text = $DepthCounter.text
	$DepthReachedValue.show()
	$MetersReached.show()



func update_depth(depth):
	$DepthCounter.text = str(depth)


func _on_message_timer_timeout() -> void:
	$Message.hide()
