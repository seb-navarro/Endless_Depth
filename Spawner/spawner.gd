extends Node2D

@export var enemy_scene: PackedScene
@export var rock_scene: PackedScene
@export var metal_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	var direction = enemy_spawn_location.rotation + PI / 2

	enemy.position = enemy_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction

	var velocity = Vector2(randf_range(200, 300), 0)
	enemy.linear_velocity = velocity.rotated(direction)

	var sprite = enemy.get_node("AnimatedSprite2D")

	if enemy_spawn_location.progress_ratio > 0.5:
		sprite.flip_v = true
		
	add_child(enemy)
	
	

func _on_obstacle_timer_timeout() -> void:
	var choice = randf()
	var obstacle
	
	if choice > 0.5:
		obstacle = rock_scene.instantiate()
	else:
		obstacle = metal_scene.instantiate()
	
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()
	
	obstacle.rotation = randf_range(0, 360)
	
	obstacle.position = obstacle_spawn_location.position
	
	obstacle.linear_velocity = Vector2(0, -50)
	
	add_child(obstacle)
