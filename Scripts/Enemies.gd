extends Node2D

@onready var enemy_unit = preload("res://Scenes/enemy.tscn")

@onready var enemies_alive = 0
@onready var current_wave = 0
@onready var rng = RandomNumberGenerator.new()
@onready var waiting = false


var wave_array = []
var max_stats


#code to get set wave compositions
var content # variable to hold all wave data gets loaded on ready
var current_wave_comp #holds current wave composition as array

func _ready():

	set_wave_array()

func _process(_delta):
	print(get_tree().get_nodes_in_group("enemy").size())
	if get_tree().get_nodes_in_group("enemy").size() <=0 and waiting == false:
	
		$spawn_cooldown.start(10)
		waiting = true
	Currency.time_to_next_wave = $spawn_cooldown.time_left


func _on_spawn_cooldown_timeout():
	set_wave_array()
	waiting = false
#	if current_wave_comp.is_empty():
#		current_wave_comp = load_current_wave()
#	else:
#		current_wave_comp.clear()
#		current_wave_comp = load_current_wave()
	if wave_array.size() > 10:
		var counter = 0
		for unit in wave_array:
			
			counter += 1
			if counter > 10:
				await get_tree().create_timer(10).timeout
				counter = 0
			else:
				spawn(unit)
	else:
		for unit in wave_array:
			spawn(unit)
	Currency.current_wave = current_wave + 1
	current_wave += 1


#func load_wave_file():
#	if FileAccess.file_exists("res://Scripts/waves.txt"):
#
#		var file = FileAccess.open("res://Scripts/waves.txt",FileAccess.READ)
#		content = file.get_as_text()
#		current_wave_comp =  load_current_wave()
#
#
#
#func load_current_wave(): # loads current wave composition to be used by
#	var temp_comp  = content.get_slice("\n", current_wave).split(",")
#	temp_comp.remove_at(0)
#	return temp_comp

func spawn(type):
	var e = enemy_unit.instantiate()
	var spawn_pos = find_spawn_loc()
	e.position = spawn_pos
	e.set_type(type)
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

func set_wave_array():
	var random = RandomNumberGenerator.new()
	find_max_stats()
	if !wave_array.is_empty():
		wave_array.clear()
	var temp_max_stats = max_stats
	while temp_max_stats > 0:
		var unit_value = random.randi_range(1,100)
		if unit_value >= 1 and unit_value <= 40:
			wave_array.append("AR") #adds archer with 40% chance
			temp_max_stats -= 11
		elif unit_value < 40 and unit_value <= 60:
			wave_array.append("SW") # adds swordsman at 20% chance
			temp_max_stats -= 18
		elif unit_value < 60 and unit_value <= 85:
			wave_array.append("SP") # adds spearman at 25% chance
			temp_max_stats -= 15
		elif unit_value < 85 and unit_value <=100:
			wave_array.append("KN") # adds knight at 15% chance
			temp_max_stats -= 29
	print(wave_array)

func find_max_stats():
	var temp_max = (Currency.current_wave + ((Currency.current_wave ** Gamestate.difficulty) + 50))
	max_stats = temp_max
	print(temp_max)
