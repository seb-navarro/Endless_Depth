extends Control

var pressed
var movement = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Subamrine.play("subamrine_menu")
	pressed = false
	$Fade/ColorRect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressed == true:
		$Subamrine.position.y += movement * delta
		$Subamrine.speed_scale = 10


func _on_menu_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_start_button_released() -> void:
	$MenuTimer.start()
	$AnimationTimer.start()
	pressed = true
	$StartButton.visible = false

func transition_out():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_out")
	

func _on_animation_timer_timeout() -> void:
	transition_out()
