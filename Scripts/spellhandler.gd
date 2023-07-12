extends Node

var current_spell = "steal"
var explode_cooldown = false # is explode spell on cooldown
var steal_cooldown = false # same for steal spell
var raise_cooldown = false
var mouse_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("left click"):
		print(mouse_pos)

func steal_soul():
	pass

func target(enemy):
	if current_spell == "explode" and not explode_cooldown:
		if Currency.use_soul(5):
			explode_cooldown = true
			enemy.explode()
		else:
			pass # not enough souls popup would be nice
	elif current_spell == "steal" and not steal_cooldown:
		steal_cooldown = true
		enemy.soul_particle()
		Currency.add_soul(1)
	elif current_spell == "raise" and not raise_cooldown:
		if Currency.use_soul(7):
			raise_cooldown = true
			enemy.raise()
		else:
			pass # not enough $ popup
