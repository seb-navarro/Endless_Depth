extends Node

@export var enemy_scene: PackedScene
var fuel = 100
var depth = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fuel <= 0:
		game_over()
	
	$HUD/FuelGauge.value = fuel


func _on_player_hit() -> void:
	fuel -= 10

func new_game():
	fuel = 100
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	var direction = enemy_spawn_location.rotation + PI / 2

	enemy.position = enemy_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	add_child(enemy)



func _on_fuel_deplete_timeout() -> void:
	fuel -= 1


func _on_start_timer_timeout() -> void:
	$EnemyTimer.start()
	$FuelDeplete.start()
	$DepthTimer.start()

func game_over():
	$EnemyTimer.stop()
	$FuelDeplete.stop()
	$DepthTimer.stop()
	$HUD.show_game_over()


func _on_depth_timer_timeout() -> void:
	depth += 1
	$HUD.update_depth(depth)
