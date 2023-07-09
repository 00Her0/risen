extends Area2D

@export var health = 200
@onready var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(power):
	health -= power
	if health <= 0:
		broken = true
		print("game over nerd xDDD") # game over code here
