extends CharacterBody2D

signal hit

var screen_size
var speed = 100
var gravity = 5000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	velocity.y = gravity * delta
	
	var direction = 0
	
	if Input.is_action_pressed("move_right"):
		direction += 1
	elif Input.is_action_pressed("move_left"):
		direction -= 1
	
	velocity.x = direction * speed
	
	move_and_slide()
	
	check_collision()
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	var player_size = Vector2(64, 64)
	
	position.x = clamp(position.x, 0 + player_size.x / 2, screen_size.x - player_size.x / 2)
	#position.y = clamp(position.x, 0 + player_size.y / 2, screen_size.y - player_size.y / 2)
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0



func check_collision():
	if get_slide_collision_count() > 0:
		hit.emit()
		$AnimatedSprite2D.animation = "submarine_hit"
		$CollisionPolygon2D.disabled = true
		$HitTimer.start()



func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false


func _on_hit_timer_timeout() -> void:
	$AnimatedSprite2D.animation = "submarine"
	$CollisionPolygon2D.disabled = false
