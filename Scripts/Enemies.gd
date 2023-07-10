extends Node2D

@onready var e = preload("res://Scenes/enemy.tscn")
@onready var waves = [ # I made it this way so we can add different types of enemies leter more easily
	[[e],[e,e,e],[e,e,e]], # this is one wave
	[[e,e]], # e means one enemy, so this wave has two enemies that spawn at the same
	[[e,e],[e,e]],
	[[e,e,e,e],[e,e,e]],
	[[e,e],[e,e,e,e,e,e,e]],
	[[e,e,e,e,e,e],[e,e,e]] # this wave has two groups, one spawns then five seconds later the other spawns
	# josh if that doesnt make sense just @ me on discord :)
	# I like that because later we can change the letters to mean 
	# different units later and have stats vary depending on unit and wave
]
@onready var enemies_alive = 0
@onready var current_wave = 0
@onready var rng = RandomNumberGenerator.new()
@export var wave_multiplier = 1.05

func wave(num):
	if num > 2: # since theres only 2 waves rn this cuts it after 2
		return
	enemies_alive = 0
	for i in waves[num]:
		for x in i:
			enemies_alive += 1
			var enemy = x.instantiate()
			if current_wave > 0:
				enemy.health = enemy.health * (wave_multiplier * current_wave)
				print(enemy.health)
			enemy.position.x = 32 # to make spawning visible for debugging
			enemy.position.y = rng.randf_range(270, 500)
			enemy.i_died.connect(enemy_died)
			add_child(enemy)
			enemy = null
		await(get_tree().create_timer(5).timeout)

func enemy_died(_enemy):
	enemies_alive -= 1

func _process(_delta):
	if enemies_alive == 0:
		$spawn_cooldown.start()
		enemies_alive = -1
		print("starting")


func _on_spawn_cooldown_timeout():
	wave(current_wave)
	print("wave " + str(current_wave))
	current_wave += 1
