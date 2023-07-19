extends Area2D

@export var health = 200
@onready var broken = false

func _ready():
	Currency.wall_hp = health
	Gamestate.wall = self
	
func _process(_delta):
	if health <= 0:
		Gamestate.state = "lose"

func take_damage(power):
	health -= power
	Currency.wall_hp = health
	if health <= 0:
		broken = true

