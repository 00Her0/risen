extends Area2D

@export var health = 200
@onready var broken = false

func _ready():
	Currency.wall_hp = health

func take_damage(power):
	health -= power
	Currency.wallhp = health
	if health <= 0:
		broken = true
		print("game over nerd xDDD") # game over code here
