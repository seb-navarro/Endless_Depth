extends Area2D

signal hit

@export var speed = 5
var screen_size
var down = 1000
var velocity = Vector2.ZERO
var currentposx
var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_size = Vector2(64, 64)
	
	var currentpos = position.x
	
	velocity.y = down * delta
	
	if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
		velocity.y = down * delta * 4
		$AnimatedSprite2D.speed_scale = 10
	elif Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$AnimatedSprite2D.speed_scale = 1
	elif Input.is_action_pressed("move_right"):
		velocity.x += speed
		$AnimatedSprite2D.speed_scale = 1
	else:
		$AnimatedSprite2D.speed_scale = 1
	
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	position.x = clamp(position.x, 0 + player_size.x / 2, screen_size.x - player_size.x / 2)
	
	if position.x == 0 + player_size.x / 2 or position.x == screen_size.x - player_size.x / 2:
		velocity.x = 0
	
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
