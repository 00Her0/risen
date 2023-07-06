extends Node2D

@onready var e = preload("res://Scenes/enemy.tscn")
@onready var waves = [ # I made it this way so we can add different types of enemies leter more easily
	[[e]],
	[[e,e]],
	[[e,e],[e,e]]
]
@onready var enemies_alive = 0
@onready var current_wave = 0
@onready var rng = RandomNumberGenerator.new()

func wave(num):
	if num > 2:
		return
	enemies_alive = 0
	for i in waves[num]:
		for x in i:
			enemies_alive += 1
			var enemy = x.instantiate()
			enemy.position.x = 32 # to make spawning visible for debugging
			enemy.position.y = rng.randf_range(32, 508)
			enemy.i_died.connect(enemy_died)
			add_child(enemy)
			enemy = null
		await(get_tree().create_timer(1).timeout)

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
