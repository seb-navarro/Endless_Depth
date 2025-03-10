extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SuccessMessage.hide()
	$FailedMessage.hide()
	$LoadingMessage.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# When the submit button is released, the result is sent to the online leaderboard.
# Whilst the request is being processed a loading screen shows.
# If this is successful a message indicates this.
# If it is not successful then a failed message displays informing the user that their score is saved but currently it could not be uploaded.
# The failed upload is stored in local storage using the "Quiver" plugin so that it can be uploaded again next time the app open with an internet connection.
func _on_submit_button_released() -> void:
	$BlackBackground/ColorRect/SubmitButton.hide()
	if Global.soundfx == true:
		$ButtonSound.play()
		
	if Global.vibrate == true:
		Input.vibrate_handheld(100)
	var nickname = $BlackBackground/ColorRect/NicknameInput.get_text()
	$LoadingMessage.show()
	$BlackBackground/ColorRect/NicknameInput.hide()
	$BlackBackground/ColorRect.hide()
	var result = await Leaderboards.post_guest_score("endless-depth-endless-depth-h-wUts", Global.high_score, nickname)
	Global.save_score(Global.high_score)
	
	if result == true:
		$SuccessMessage.show()
		$LoadingMessage.hide()
		$WaitTimer.start(2)
	elif result == false:
		$FailedMessage.show()
		$LoadingMessage.hide()
		$WaitTimer.start(10)
	

# Once the player has submitted they are returned to the main menu.
func _on_wait_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
