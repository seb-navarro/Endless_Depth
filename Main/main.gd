extends Node

var fuel
var depth
var gameover
var loop = true
var exit = true 
var check

signal checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Checks the previous scene and adjusts the main gameplay scene accordingly.
	# Difficulty variable increases after each refuel.
	if Global.previous_scene == "refuel":
		Global.difficulty = Global.difficulty * 0.75
	elif Global.previous_scene == "menu":
		BackgroundMusic.play()
		Global.run_fuel = 100
		Global.run_depth = 0
		Global.difficulty = 1
	
	# Difficulty applied.
	$Spawner/EnemyTimer.wait_time = Global.difficulty
	$Spawner/ObstacleTimer.wait_time = Global.difficulty
	fuel = Global.run_fuel
	depth = Global.run_depth + 1
	exit = true
	loop = true
	# Places player in the middle of the screen area.
	$Player.position.x = Global.screen_width / 2
	$Player.position.y = Global.screen_height / 2
	gameover = false
	$Fade/ColorRect.visible = true
	# Fades in to scene.
	transition_in()
	$StartTimer.start()
	# Keeps the enemies and obtsacles spawning in accordance to the player position.
	$Spawner.position = $Player.position
	$HUD.update_depth(depth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Spawner.position.y = $Player.position.y
	
	# When the fuel runs out the game is over.
	if gameover == false:
		if fuel <= 0:
			game_over()
			
	# Checks if a refuel station has been reached.
	if loop == true:
		if check == 0:
			loop = false
			refuel()
	
	# Checks when to fade out of the scene when refuelling.
	if exit == true:
		if $Player.position.x >= Global.screen_width + $Player.player_size.x / 2:
			transition_out()
			$Fade/TransitionTimer.start()
			exit = false
	
	# Fuel is updated in the fuel gauge ever frame.
	$HUD/FuelGauge.value = fuel
	
	# Fuel drops 1 every second, Depth drops 1 every 0.5 of a second.
	$FuelDeplete.wait_time = 1
	$DepthTimer.wait_time = 0.5


# When a player is hit the hit sound is played and the player loses 10 fuel.
func _on_player_hit() -> void:
	fuel -= 10
	$HitSound.play()


func _on_fuel_deplete_timeout() -> void:
	fuel -= 1

# Starts the spawning of enemies, obstacles, and begins depletiting fuel and increasing depth.
func _on_start_timer_timeout() -> void:
	$Spawner/EnemyTimer.start()
	$Spawner/ObstacleTimer.start()
	$FuelDeplete.start()
	$DepthTimer.start()

# Function to trigger a "Game Over". The camera stops following the payer and the player sinks to the bottom.
# A Game Over message is displayed and if a personal best is achieved then that is displayed too.
# If a Personal best is achieved then that score is saved to the external file.
func game_over():
	if depth > Global.high_score:
		$HUD/PersonalBest.show()
		
	
	$Spawner/EnemyTimer.stop()
	$Spawner/ObstacleTimer.stop()
	$FuelDeplete.stop()
	$DepthTimer.stop()
	$HUD.show_game_over()
	$HUD/Fuel.hide()
	$HUD/FuelGauge.hide()
	$HUD/Left.hide()
	$HUD/Right.hide()
	$HUD/Depth.hide()
	$HUD/DepthCounter.hide()
	$HUD/DepthGauge.hide()
	$HUD/Meters.hide()
	$Player/Camera2D.limit_bottom = $Player.position.y + $Player/Camera2D.get_viewport().get_visible_rect().size.y / 2
	$Player.over()
	$Fade/FadeTimer.start()
	BackgroundMusic.stop()
	$SinkSound.play()
	gameover = true


# Increases depth and checks if the player has reached 100 meters.
# Every 100 meters there is a refuel station.
func _on_depth_timer_timeout() -> void:
	check = depth % 100
	if check != 0:
		depth += 1
		$HUD.update_depth(depth)
	else:
		$RefuelSound.play()
		$HUD.show_message("REFUEL STATION ->", 10, "#ffc900")
		$Player.down = 0
		Input.vibrate_handheld(100)


# When a player boosts the player sinks twice as fast but also uses up twice as much fuel.
func _on_player_boost() -> void:
	$FuelDeplete.wait_time = $FuelDeplete.wait_time * 0.5
	$DepthTimer.wait_time = $DepthTimer.wait_time * 0.5

# Function to transition into the scene
func transition_in():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_in")

# Function to transition out of the scene
func transition_out():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_out")
	
	
# Called when its time to refuel
# Stores the current depth and fuel in a global variable for retrieval in a different scene.
func refuel():
	$DepthTimer.stop()
	$FuelDeplete.stop()
	Global.run_depth = depth
	Global.run_fuel = fuel
	checkpoint.emit()

# Timer runs until the player is off screen, after this the scene transitions out.
# Used on a "Game Over".
func _on_fade_timer_timeout() -> void:
	transition_out()
	$Fade/TransitionTimer.start()


# Exits into a different scene
# This is decided by whether the player exited out of the right side of the screen or the bottom.
func _on_transition_timer_timeout() -> void:
	if $Player.position.x >= Global.screen_width + $Player.player_size.x / 2:
		Global.previous_scene = "gameplay"
		get_tree().change_scene_to_file("res://Refuel/Refuel.tscn")
	else:
		Global.previous_scene = "gameplay"
		# If there is a new high score then the user is taken to the submit score scene.
		if depth > Global.high_score:
			Global.high_score = depth
			get_tree().change_scene_to_file("res://Leaderboard/SubmitScore/submit_score.tscn")
		else:
			get_tree().change_scene_to_file("res://Menu/Menu.tscn")
		
