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
	if Global.previous_scene == "refuel":
		Global.difficulty = Global.difficulty * 0.75
	elif Global.previous_scene == "menu":
		BackgroundMusic.play()
		Global.run_fuel = 100
		Global.run_depth = 0
		Global.difficulty = 1
	
	$Spawner/EnemyTimer.wait_time = Global.difficulty
	$Spawner/ObstacleTimer.wait_time = Global.difficulty
	fuel = Global.run_fuel
	depth = Global.run_depth + 1
	exit = true
	loop = true
	$Player.position.x = Global.screen_width / 2
	$Player.position.y = Global.screen_height / 2
	gameover = false
	$Fade/ColorRect.visible = true
	transition_in()
	$StartTimer.start()
	$Spawner.position = $Player.position
	$HUD.update_depth(depth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Spawner.position.y = $Player.position.y
	
	if gameover == false:
		if fuel <= 0:
			game_over()
			
	if loop == true:
		if check == 0:
			loop = false
			refuel()
	
	if exit == true:
		if $Player.position.x >= Global.screen_width + $Player.player_size.x / 2:
			transition_out()
			$Fade/TransitionTimer.start()
			exit = false
	
	$HUD/FuelGauge.value = fuel
	
	$FuelDeplete.wait_time = 1
	$DepthTimer.wait_time = 0.5


func _on_player_hit() -> void:
	fuel -= 10
	$HitSound.play()
	Input.vibrate_handheld(100)


func _on_fuel_deplete_timeout() -> void:
	fuel -= 1


func _on_start_timer_timeout() -> void:
	$Spawner/EnemyTimer.start()
	$Spawner/ObstacleTimer.start()
	$FuelDeplete.start()
	$DepthTimer.start()

func game_over():
	if depth > Global.high_score:
		Global.save_score(depth)
		Global.high_score = depth
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


func _on_depth_timer_timeout() -> void:
	check = depth % 100
	if check != 0:
		depth += 1
		$HUD.update_depth(depth)
	else:
		$RefuelSound.play()
		$HUD.show_message("REFUEL STATION ->", 10, "#ffc900")
		$Player.down = 0


func _on_player_boost() -> void:
	$FuelDeplete.wait_time = $FuelDeplete.wait_time * 0.5
	$DepthTimer.wait_time = $DepthTimer.wait_time * 0.5

func transition_in():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_in")

func transition_out():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_out")
	
	
func refuel():
	$DepthTimer.stop()
	$FuelDeplete.stop()
	Global.run_depth = depth
	Global.run_fuel = fuel
	checkpoint.emit()


func _on_fade_timer_timeout() -> void:
	transition_out()
	$Fade/TransitionTimer.start()


func _on_transition_timer_timeout() -> void:
	if $Player.position.x >= Global.screen_width + $Player.player_size.x / 2:
		Global.previous_scene = "gameplay"
		get_tree().change_scene_to_file("res://Refuel/Refuel.tscn")
	else:
		Global.previous_scene = "gameplay"
		get_tree().change_scene_to_file("res://Menu/Menu.tscn")
