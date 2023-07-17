extends Node2D

@onready var e = preload("res://Scenes/enemy.tscn")
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
@onready var enemies_alive = 0
@onready var current_wave = 0
@onready var rng = RandomNumberGenerator.new()
@onready var spawning_bool = false
@export var wave_multiplier = 1.05


func _ready():
	$spawn_cooldown.start()

func wave(num):
#	if num > 2: # since theres only 2 waves rn this cuts it after 2
#		return
	enemies_alive = 0
	for i in waves[num]:
		for x in i:
			enemies_alive += 1
			var enemy = x.instantiate()
			if current_wave > 0:
				enemy.health = enemy.health * (wave_multiplier * current_wave)
			enemy.position.x = 32 # to make spawning visible for debugging
			enemy.position.y = rng.randf_range(270, 500)
			enemy.i_died.connect(enemy_died)
			add_child(enemy)
			enemy = null
		await(get_tree().create_timer(5).timeout)

func enemy_died(_enemy):
	enemies_alive -= 1

func _process(_delta):
	if enemies_alive == 0 and $spawn_cooldown.time_left == 0:
		spawning_bool = false
	if current_wave < 10 and spawning_bool == false:
		$spawn_cooldown.start()
		spawning_bool = true
	elif current_wave == 10 and enemies_alive == 0:
		Gamestate.state = "win"



func _on_spawn_cooldown_timeout():
	wave(current_wave)
	Currency.current_wave = current_wave
	current_wave += 1
