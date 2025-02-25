extends Control

var pressed
var movement = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Subamrine.play("subamrine_menu")
	pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressed == true:
		$Subamrine.position.y += movement * delta
		$Subamrine.speed_scale = 10


func _on_menu_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Main/Main.tscn")


func _on_start_button_released() -> void:
	$MenuTimer.start()
	pressed = true
	$StartButton.visible = false
