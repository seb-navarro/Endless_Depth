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
var config = ConfigFile.new()
const save_path = "user://player_high_score.save"
const settings_path = "user://user_settings.ini"


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
	
	load_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Function used to load the user's high score.
func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
		file.close()
	else:
		high_score = 0

# Function used to save the user's high score.
func save_score(score):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(score)
	file.close()
	
	
	
# Function to save settings to a config file.
func save_settings():
	config.set_value("settings", "music", music)
	config.set_value("settings", "soundfx", soundfx)
	config.set_value("settings", "vibrate", vibrate)
	
	var error = config.save(settings_path)
	# If there is an error then default to all settings being true.
	if error != OK:
		music = true
		soundfx = true
		vibrate = true


# Function to load settings from a config file.
func load_settings():
	var error = config.load(settings_path)
	if error == OK:
		music = config.get_value("settings", "music", true)
		soundfx = config.get_value("settings", "soundfx", true)
		vibrate = config.get_value("settings", "vibrate", true)
	else:
		# If the file is not found then the settings are saved to a file with their default "true" values.
		save_settings()
