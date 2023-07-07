extends Node

var current_spell = ""
var explode_cooldown = false # is explode spell on cooldown
var steal_cooldown = false # same for steal spell
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
	if current_spell == "explode" and not explode_cooldown and Currency.use_soul(5):
		explode_cooldown = true
		enemy.explode()
	elif current_spell == "steal" and not steal_cooldown:
		steal_cooldown = true
		Currency.add_soul(1)
		enemy.queue_free() # get rid of the evidence >:)
