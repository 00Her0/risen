extends Node2D

@onready var e = preload("res://Scenes/enemy.tscn")
@onready var enemy_unit = preload("res://Scenes/enemy.tscn")
@onready var waves = [ # I made it this way so we can add different types of enemies leter more easily
	[[e],[e,e,e],[e,e,e]], # this is one wave
	[[e,e]], # e means one enemy, so this wave has two enemies that spawn at the same
	[[e,e],[e,e]],
	[[e,e,e,e],[e,e,e]],
	[[e,e],[e,e,e,e,e,e,e]],
	[[e,e,e,e,e,e],[e,e,e]],
	[[e,e,e,e,e,e,e,e,e]],
	[[e,e,e,e,e,e,e,e,]],
	[[e,e,e,e,e,e,e,e,e,e]],
	[[e,e,e,e,e,e,e,e,e,e,e,]]
	]
@onready var wave_times = [10,20,40,40,40,40,40,40,60,60]
@onready var enemies_alive = 0
@onready var current_wave = 0
@onready var rng = RandomNumberGenerator.new()
@onready var spawning_bool = false
@export var wave_multiplier = 1.05

#code to get set wave compositions
var content # variable to hold all wave data gets loaded on ready
var current_wave_comp #holds current wave composition as array

func _ready():
	Currency.time_to_next_wave = wave_times[current_wave]
	load_wave_file()


#func _process(_delta):
#	if enemies_alive == 0 and $spawn_cooldown.time_left == 0:
#		spawning_bool = false
#	if current_wave < 10 and spawning_bool == false:
#		$spawn_cooldown.start(wave_times[current_wave])
#		spawning_bool = true
#	elif current_wave == 10 and enemies_alive == 0:
#		Gamestate.state = "win"



func _on_spawn_cooldown_timeout():
	for unit in current_wave_comp:
		spawn(unit)
	Currency.current_wave = current_wave + 1
	Currency.time_to_next_wave = wave_times[current_wave]
	current_wave += 1
	$spawn_cooldown.start(wave_times[current_wave])


func load_wave_file():
	var file = FileAccess.open("res://Scripts/waves.txt",FileAccess.READ)
	content = file.get_as_text()
	current_wave_comp =  load_current_wave()
	print(current_wave_comp)


func load_current_wave(): # loads current wave composition to be used by
	var temp_comp  = content.get_slice("\r", current_wave).split(",")
	return temp_comp

func spawn(type):
	var e = enemy_unit.instantiate()
	var spawn_pos = find_spawn_loc()
	e.position = spawn_pos
	e.assign_stats(type)
	e.health *= (wave_multiplier * max(current_wave,1))
	add_child(e)
	
	
	
func find_spawn_loc():
	var x = rng.randf_range(-140,170)
	var y
	if x < 0:
		y = rng.randf_range(440,540)
	else:
		y = rng.randf_range(540,610)
	var pos = Vector2(x,y)
	return pos
