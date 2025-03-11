extends Control

var pressed
var movement = 200
var popup_menu
var music_loop
var keep_open

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays the main theme music and fetches the high score from the global variable.
	if Global.previous_scene != "leaderboard" and Global.music == true:
		BackgroundMusic.play()
	$Subamrine.play("subamrine_menu")
	keep_open = false
	pressed = false
	$Fade/ColorRect.visible = false
	$PersonalBestTexture/PersonalBestValue.text = str(Global.high_score)
	popup_menu = $Settings.get_popup()
	popup_menu.index_pressed.connect(on_index_pressed)
	
	# Stops the background music from restarting when going into the leaderboards menu.
	if Global.previous_scene == "leaderboard":
		music_loop = false
	else:
		music_loop = true
	
	# Displays correct checkboxes depending on the global variable that is linked with the setting.
	if Global.music == false:
		popup_menu.set_item_checked(0, false)
	else:
		popup_menu.set_item_checked(0, true)
	
	if Global.soundfx == false:
		popup_menu.set_item_checked(2, false)
	else:
		popup_menu.set_item_checked(2, true)
		
	if Global.vibrate == false:
		popup_menu.set_item_checked(4, false)
	else:
		popup_menu.set_item_checked(4, true)
	
	# Keeps the dropdown settings menu open whilst selecting settings.
	popup_menu.hide_on_checkable_item_selection = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# When the start button is pressed the submarine sinks to the bottom of the screen.
	if pressed == true:
		$Subamrine.position.y += movement * delta
		$Subamrine.speed_scale = 10
	
	# Music stops if it is unchecked in the settings menu.
	if Global.music == false:
		BackgroundMusic.stop()
		music_loop = true

	# "music_loop" is used otherwise the music would be stuck trying to start playing at every frame.
	if music_loop == true:
		if Global.music == true:
			BackgroundMusic.play()
			music_loop = false


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
	# Sound effects only play if they have not been turned off in settings menu.
	if Global.soundfx == true:
		$PressedSound.play()
	BackgroundMusic.stop()
	# Vibrate only triggers if it has not been turned off in settings menu.
	if Global.vibrate == true:
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
	if Global.soundfx == true:
		$PressedSound.play()
	$LeaderboardButton.hide()
	$StartButton.hide()
	$LeaderboardButton/LeaderboardTimer.start()
	

# When an item from the settings menu is pressed, the item can be checked and unchecked accordingly.
# Sets global variables that determine whether music, sound effects, and device vibration should be on or off.
# User settings are then saved in a local file for retrieval on each launch of the game.
func on_index_pressed(index: int):
	if popup_menu.is_item_checked(index):
		popup_menu.set_item_checked(index, false)
		if index == 0:
			Global.music = false
		elif index == 2:
			Global.soundfx = false
		elif index == 4:
			Global.vibrate = false
		Global.save_settings()
	else:
		popup_menu.set_item_checked(index, true)
		if index == 0:
			Global.music = true
		elif index == 2:
			Global.soundfx = true
		elif index == 4:
			Global.vibrate = true
		Global.save_settings()


# Timer is used so button sound can be heard before switching to new scene
func _on_leaderboard_timer_timeout() -> void:
	Global.previous_scene = "menu"
	get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
