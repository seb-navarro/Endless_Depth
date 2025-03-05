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
	# "down" variable controls the rate at which the submarine sinks.
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
	
	# Calculates rate at which the submarine sinks using down variable and delta.
	velocity.y = down * delta
	
	# If ther eis not a game over or refuel happening then the user can use the touch screen buttons to move left, right, or boost.
	# The user can boost by holding down both left and right buttons at the same time.
	# During boosting the animation plays 10 times as fast to indicate to the user that the boost is taking place.
	if finish == false and refuel == false:
		if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
			velocity.y = down * delta * 2
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
	# During a game over the player sinks to the bottom of the screen.
	elif finish == true:
		velocity.x = 0
		$AnimatedSprite2D.speed_scale = 1
		$AnimatedSprite2D.animation = "sink"
		velocity.y = down * delta * 2
		collision_layer = 0
		collision_mask = 0
	# During a refuel the player cannot be hit and exits out the right of the screen following a short stop still.
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
	
	# Moves the player using the velocity and delta values.
	position += velocity * delta
	
	# If a refuel is not taking place then the player cannot exit the left or right sides of the screen.
	# The top and bottom are not clamped because the player is infinitely sinking downwards and can never move in an upwards direction.
	if refuel == false:
		position.x = clamp(position.x, 0 + player_size.x / 2, Global.screen_width - player_size.x / 2)
		
		# Sets rhe velocity to 0 when the player hits the screen limit.
		# This stops the velocity increasing from holding down a button even though the player is not moving.
		if position.x == 0 + player_size.x / 2 or position.x == Global.screen_width - player_size.x / 2:
			velocity.x = 0
	
	# Flips the sprite horizontaly to the direction it is moving.
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


# When an enemy or obstacle enters the player collision area the player becomes unable to be hit again for a short period and a hit animation plays.
func _on_body_entered(body: Node2D) -> void:
	if finish == false:
		collision_layer = 0
		collision_mask = 0
		hit.emit()
		if boosting == false:
			$AnimatedSprite2D.animation = "submarine_hit"
			been_hit = true
		else:
			# A slow hit animation is implemented to handle the increase in animation speed whilst boosting.
			$AnimatedSprite2D.animation = "slow_hit"
			keep_boost = true
		$HitTimer.start()

# Makes the player able to collide with enemies and obstacles again following the initial hit.
func _on_hit_timer_timeout() -> void:
	if finish == false:
		$AnimatedSprite2D.animation = "submarine"
		collision_layer = 1
		collision_mask = 1
		keep_boost = false
		been_hit = false
	

# Begins the game over sequence.
func over():
	finish = true

# Begins the refuel sequence.
func _on_main_checkpoint() -> void:
	refuel = true
	
# When a refuel station is reached the player pauses before exiting off screen to the right.
# This function is to handle the pause finishing.
func _on_wait_timer_timeout() -> void:
	wait = true
