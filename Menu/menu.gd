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
	
	if Global.previous_scene == "leaderboard":
		music_loop = false
	else:
		music_loop = true
	
	if Global.music == false:
		popup_menu.set_item_checked(0, false)
	
	if Global.soundfx == false:
		popup_menu.set_item_checked(2, false)
		
	if Global.vibrate == false:
		popup_menu.set_item_checked(4, false)
		
	popup_menu.hide_on_checkable_item_selection = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# When the start button is pressed the submarine sinks to the bottom of the screen.
	if pressed == true:
		$Subamrine.position.y += movement * delta
		$Subamrine.speed_scale = 10
	
	if popup_menu.is_item_checked(0):
		Global.music = true
	else:
		Global.music = false

	if popup_menu.is_item_checked(2):
		Global.soundfx = true
	else:
		Global.soundfx = false

	if popup_menu.is_item_checked(4):
		Global.vibrate = true
	else:
		Global.vibrate = false
	
	
	if Global.music == false:
		BackgroundMusic.stop()
		music_loop = true

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
	if Global.soundfx == true:
		$PressedSound.play()
	BackgroundMusic.stop()
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
	

func on_index_pressed(index: int):
	if popup_menu.is_item_checked(index):
		popup_menu.set_item_checked(index, false)
	else:
		popup_menu.set_item_checked(index, true)



# Timer is used so button sound can be heard before switching to new scene
func _on_leaderboard_timer_timeout() -> void:
	Global.previous_scene = "menu"
	get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
