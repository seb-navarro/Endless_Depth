extends Camera2D

@export var enemy_scene: PackedScene



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	add_child(enemy)
