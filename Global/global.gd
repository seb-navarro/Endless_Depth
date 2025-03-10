extends Node

var screen_height
var screen_width
var run_fuel
var run_depth
var high_score
var previous_scene
var difficulty = 1.0
var music
var soundfx
var vibrate
const save_path = "user://player_high_score.save"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Screen height and width are determined by the device the game is played on.
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	# "run" variables keep track of the fuel and depth of the current playthrough.
	run_fuel = 100
	run_depth = 0
	# Loads the user's high score from the file.
	load_score()
	
	# Variables that track the settings toggled in the settings menu.
	music = true
	soundfx = true
	vibrate = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Function used to load the user's high score.
func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0

# Function used to save the user's high score.
func save_score(score):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(score)
	
