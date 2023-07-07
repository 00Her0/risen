extends Node

var current_spell = ""
var mouse_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("left click"):
		print(mouse_pos)

func steal_soul():
	pass

func target(enemy):
	if current_spell == "explode":
		enemy.explode()
