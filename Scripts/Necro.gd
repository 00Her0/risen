extends Sprite2D


@onready var bone_spear = preload("res://Scenes/bonespear.tscn")
@onready var muzzle = $Muzzle
var target = null


func shoot(target):
	#activate bone spear and fire it at current mouse position
	muzzle.look_at(target)
	var b = bone_spear.instantiate()
	add_child(b)
	b.start(muzzle.global_transform)

func _process(_delta):
	#Fire the bone spear
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "bone_spear":
		if Spellhandler.bone_spear_cooldown == false:
			if Spellhandler.mouse_pos.x > 285 or Spellhandler.mouse_pos.y > 155:
				shoot(Spellhandler.mouse_pos)
				Spellhandler.bone_spear_cooldown = true
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "iron_maiden":
		Spellhandler.iron_maiden_cooldown = true
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "weaken":
		Spellhandler.weaken_cooldown = true
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "golem":
		Spellhandler.golem_summoned = true
