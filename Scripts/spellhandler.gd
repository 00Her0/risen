extends Node

@onready var popup = preload("res://Scenes/pop_up.tscn")
var current_spell = "steal"
var explode_cooldown = false # is explode spell on cooldown
var steal_cooldown = false # same for steal spell
var raise_cooldown = false
var bone_spear_cooldown = false
var iron_maiden_cooldown = false
var weaken_cooldown = false
var golem_summoned = false
var mouse_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_pos = get_viewport().get_mouse_position()

func target(enemy, right := false):
	if right:
		enemy.soul_particle()
		Currency.add_soul(1)
	if current_spell == "explode" and not explode_cooldown:
		if Currency.use_soul(6):
			explode_cooldown = true
			enemy.explode()
		else:
			pass # not enough souls popup would be nice
	elif current_spell == "raise" and not raise_cooldown:
		if Currency.use_soul(2):
			raise_cooldown = true
			enemy.raise()
		else:
			pass # not enough $ popup

func make_popup(where, title, text):
	var temp = popup.instantiate()
	temp.pop_up(where, title, text)
	add_child(temp)
	return temp
