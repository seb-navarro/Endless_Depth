extends Node

var fuel = 100
var depth = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade/ColorRect.visible = true
	transition_in()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Spawner.position = $Player.position
	
	if fuel <= 0:
		game_over()
	
	$HUD/FuelGauge.value = fuel
	
	$FuelDeplete.wait_time = 1
	$DepthTimer.wait_time = 0.5


func _on_player_hit() -> void:
	fuel -= 10

func new_game():
	fuel = 100
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_fuel_deplete_timeout() -> void:
	fuel -= 1


func _on_start_timer_timeout() -> void:
	$Spawner/EnemyTimer.start()
	$Spawner/ObstacleTimer.start()
	$FuelDeplete.start()
	$DepthTimer.start()

func game_over():
	$Spawner/EnemyTimer.stop()
	$Spawner/ObstacleTimer.stop()
	$FuelDeplete.stop()
	$DepthTimer.stop()
	$HUD.show_game_over()


func _on_depth_timer_timeout() -> void:
	depth += 1
	$HUD.update_depth(depth)


func _on_player_boost() -> void:
	$FuelDeplete.wait_time = $FuelDeplete.wait_time * 0.5
	$DepthTimer.wait_time = $DepthTimer.wait_time * 0.25

func transition_in():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_in")
