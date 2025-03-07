extends Control

var pressed
var movement = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays the main theme music and fetches the high score from the global variable.
	if Global.previous_scene != "leaderboard":
		BackgroundMusic.play()
	$Subamrine.play("subamrine_menu")
	pressed = false
	$Fade/ColorRect.visible = false
	$PersonalBestTexture/PersonalBestValue.text = str(Global.high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# When the start button is pressed the submarine sinks to the bottom of the screen.
	if pressed == true:
		$Subamrine.position.y += movement * delta
		$Subamrine.speed_scale = 10


# Sets the previous scene for retrieval in the following scene.
# Transitions to main gameplay scene.
func _on_menu_timer_timeout() -> void:
	Global.previous_scene = "menu"
	get_tree().change_scene_to_file("res://Main/Main.tscn")


# When the start button is released a sequence begins to begin the game.
# Vibration is used to indicate the button was pressed.
func _on_start_button_released() -> void:
	$Fade/FadeTimer.start()
	pressed = true
	$StartButton.visible = false
	$LeaderboardButton.hide()
	$PressedSound.play()
	BackgroundMusic.stop()
	Input.vibrate_handheld(100)


# Fades out of scene
func transition_out():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_out")
	$Fade/TransitionTimer.start()
	

# Changes scene
func _on_animation_timer_timeout() -> void:
	transition_out()
	

# Opens the online leaderboard
func _on_leaderboard_button_released() -> void:
	$PressedSound.play()
	$LeaderboardButton.hide()
	$StartButton.hide()
	$LeaderboardButton/LeaderboardTimer.start()

# Timer is used so button sound can be heard before switching to new scene
func _on_leaderboard_timer_timeout() -> void:
	Global.previous_scene = "menu"
	get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
