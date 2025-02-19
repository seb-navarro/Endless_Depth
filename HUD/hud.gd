extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Message.hide()
	$PersonalBest.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_message(text, time):
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = time
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over", 5)


func show_refuelling():
	show_message("Refuelling...", 15)
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$MessageTimer.hide()


func update_depth(depth):
	$DepthCounter.text = str(depth)


func _on_message_timer_timeout() -> void:
	$Message.hide()
