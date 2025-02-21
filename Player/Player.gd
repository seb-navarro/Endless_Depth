extends Area2D

signal hit

@export var speed = 300
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta

	var player_size = Vector2(64, 64)
	position.x = clamp(position.x, 0 + player_size.x / 2, screen_size.x - player_size.x / 2)
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$AnimatedSprite2D.animation = "submarine_hit"
	$HitTimer.start()


func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false


func _on_hit_timer_timeout() -> void:
	$AnimatedSprite2D.animation = "submarine"
