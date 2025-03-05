extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays the fish animation.
	$AnimatedSprite2D.play("swim")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
