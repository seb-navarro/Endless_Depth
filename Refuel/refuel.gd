extends Node

var screen_width = 480
var screen_height = 720
const refuel_station_size = Vector2(200, 200)
const submarine_size = Vector2(64, 64)
var submarine_limit = screen_width - refuel_station_size.x
var movement = 200
var loop = false
var fuel = 10
var depth = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/FuelGauge.value = fuel
	$HUD/Left.hide()
	$HUD/Right.hide()
	$HUD/DepthCounter.text = str(depth)
	$RefuelStation.position.y = screen_height / 2
	$RefuelStation.position.x = screen_width - refuel_station_size.x / 2
	$Submarine.position.y = screen_height / 2 + submarine_size.y / 2
	$Submarine.position.x = 0 - submarine_size.x 
	$Submarine.animation = "submarine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/FuelGauge.value = fuel
	$Submarine.position.x += movement * delta
	if $Submarine.position.x >= submarine_limit:
		loop = true
	
	if loop == true:
		movement = 0
		$Submarine.animation = "submarine_still"
		$HUD.show_refuelling()
		$RefuelTimer.start()
		$FillUpTimer.start()
		loop = false
		submarine_limit += 100


func _on_refuel_timer_timeout() -> void:
	$FillUpTimer.stop()
	movement = -100
	$Submarine.animation = "exit"


func _on_fill_up_timer_timeout() -> void:
	if fuel < 100:
		fuel += 1
	else:
		print("test")
		$FillUpTimer.stop()
		$RefuelTimer.start(1)
		$HUD.show_message("Refuelling...", 1)
