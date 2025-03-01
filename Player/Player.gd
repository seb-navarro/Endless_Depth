extends Area2D

signal hit
signal boost

@export var speed = 5
var down = 3000
var velocity = Vector2.ZERO
var finish = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finish = false
	$AnimatedSprite2D.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_size = Vector2(64, 64)
	
	velocity.y = down * delta
	
	if finish == false:
		if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
			velocity.y = down * delta * 4
			$AnimatedSprite2D.speed_scale = 10
			boost.emit()
		elif Input.is_action_pressed("move_left"):
			velocity.x -= speed
			$AnimatedSprite2D.speed_scale = 1
		elif Input.is_action_pressed("move_right"):
			velocity.x += speed
			$AnimatedSprite2D.speed_scale = 1
		else:
			$AnimatedSprite2D.speed_scale = 1
	else:
		velocity.x = 0
		$AnimatedSprite2D.speed_scale = 1
		$AnimatedSprite2D.animation = "sink"
		velocity.y = down * delta * 2
		collision_layer = 0
		collision_mask = 0
	
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	#Code below implements player traversing horizontaly offscreen
	#
	#
	#if position.x < -player_size.x / 2:
	#	position.x = Global.screen_width + player_size.x / 2
	#elif position.x > Global.screen_width + player_size.x / 2:
	#	position.x = -player_size.x / 2
	
	position.x = clamp(position.x, 0 + player_size.x / 2, Global.screen_width - player_size.x / 2)
	
	if position.x == 0 + player_size.x / 2 or position.x == Global.screen_width - player_size.x / 2:
		velocity.x = 0
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body: Node2D) -> void:
	collision_layer = 0
	collision_mask = 0
	hit.emit()
	$AnimatedSprite2D.animation = "submarine_hit"
	$HitTimer.start()


func start(pos):
	position = pos
	show()


func _on_hit_timer_timeout() -> void:
	$AnimatedSprite2D.animation = "submarine"
	collision_layer = 1
	collision_mask = 1
	

func over():
	finish = true
