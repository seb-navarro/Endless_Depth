extends Area2D

signal hit
signal boost

@export var speed = 5
var down = 3000
var velocity = Vector2.ZERO
var finish = false
var boosting = false
var keep_boost = false
var been_hit = false
var refuel = false
var wait = false
var timer = false
const player_size = Vector2(64, 64)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	down = 3000
	velocity = Vector2.ZERO
	finish = false
	boosting = false
	keep_boost = false
	been_hit = false
	refuel = false
	wait = false
	timer = false
	$AnimatedSprite2D.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const player_size = Vector2(64, 64)
	
	if keep_boost == false:
		boosting = false
	
	velocity.y = down * delta
	
	if finish == false and refuel == false:
		if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
			velocity.y = down * delta * 4
			if been_hit == false:
				$AnimatedSprite2D.speed_scale = 10
			else:
				$AnimatedSprite2D.speed_scale = 1
			boost.emit()
			boosting = true
		elif Input.is_action_pressed("move_left"):
			velocity.x -= speed
			if boosting == false:
				$AnimatedSprite2D.speed_scale = 1
		elif Input.is_action_pressed("move_right"):
			velocity.x += speed
			if boosting == false:
				$AnimatedSprite2D.speed_scale = 1
		else:
			if boosting == false:
				$AnimatedSprite2D.speed_scale = 1
	elif finish == true:
		velocity.x = 0
		$AnimatedSprite2D.speed_scale = 1
		$AnimatedSprite2D.animation = "sink"
		velocity.y = down * delta * 2
		collision_layer = 0
		collision_mask = 0
	else:
		if timer == false:
			velocity.x = 0
			$WaitTimer.start()
			timer = true
		collision_layer = 0
		collision_mask = 0
		$AnimatedSprite2D.speed_scale = 1
		down = 0
		if wait == true:
			velocity.x += speed
		
	
	
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	
	#Code below implements player traversing horizontaly offscreen
	#
	#
	#if position.x < -player_size.x / 2:
	#	position.x = Global.screen_width + player_size.x / 2
	#elif position.x > Global.screen_width + player_size.x / 2:
	#	position.x = -player_size.x / 2
	if refuel == false:
		position.x = clamp(position.x, 0 + player_size.x / 2, Global.screen_width - player_size.x / 2)
	
		if position.x == 0 + player_size.x / 2 or position.x == Global.screen_width - player_size.x / 2:
			velocity.x = 0
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body: Node2D) -> void:
	if finish == false:
		collision_layer = 0
		collision_mask = 0
		hit.emit()
		if boosting == false:
			$AnimatedSprite2D.animation = "submarine_hit"
			been_hit = true
		else:
			$AnimatedSprite2D.animation = "slow_hit"
			keep_boost = true
		$HitTimer.start()


func start(pos):
	position = pos
	show()


func _on_hit_timer_timeout() -> void:
	if finish == false:
		$AnimatedSprite2D.animation = "submarine"
		collision_layer = 1
		collision_mask = 1
		keep_boost = false
		been_hit = false
	

func over():
	finish = true


func _on_main_checkpoint() -> void:
	refuel = true
	


func _on_wait_timer_timeout() -> void:
	wait = true
