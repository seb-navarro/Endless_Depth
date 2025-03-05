extends Node

var screen_width = Global.screen_width
var screen_height = Global.screen_height
const refuel_station_size = Vector2(200, 200)
const submarine_size = Vector2(64, 64)
var submarine_limit = screen_width - refuel_station_size.x
var movement = 200
var loop = false
var fuel
var depth
var full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fuel = Global.run_fuel
	depth  = Global.run_depth
	full = false
	loop = false
	$Fade/ColorRect.visible = true
	$HUD/FuelGauge.value = fuel
	$HUD/Left.hide()
	$HUD/Right.hide()
	$HUD/DepthCounter.text = str(depth)
	$RefuelStation.position.y = screen_height / 2
	$RefuelStation.position.x = screen_width - refuel_station_size.x / 2
	$Submarine.position.y = screen_height / 2 + submarine_size.y / 2
	$Submarine.position.x = 0 - submarine_size.x 
	$Submarine.play("submarine")
	transition_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/FuelGauge.value = fuel
	$Submarine.position.x += movement * delta
	if $Submarine.position.x >= submarine_limit:
		loop = true
	
	if loop == true:
		movement = 0
		$Submarine.animation = "submarine_still"
		$HUD.show_message("REFUELLING...", 11, "#ffc900")
		$RefuelTimer.start()
		$FillUpTimer.start()
		loop = false
		submarine_limit += 100
	
	if full == true:
		if $Submarine.position.x <= 0 - submarine_size.x / 2:
			transition_out()
			full = false


func _on_refuel_timer_timeout() -> void:
	$FillUpTimer.stop()
	movement = -100
	$Submarine.play("exit")
	full = true
	Global.run_fuel = 100


func _on_fill_up_timer_timeout() -> void:
	if fuel < 100:
		fuel += 1
	else:
		$FillUpTimer.stop()
		$RefuelTimer.start(1)
		$HUD.show_message("REFUELLING...", 1, "#00ff00")


func transition_in():
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_in")

func transition_out():
	$Fade/TransitionTimer.start()
	$Fade/ColorRect.visible = true
	$Fade/AnimationPlayer.play("fade_out")


func _on_transition_timer_timeout() -> void:
	Global.previous_scene = "refuel"
	get_tree().change_scene_to_file("res://Main/Main.tscn")
