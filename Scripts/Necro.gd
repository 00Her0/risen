extends Sprite2D


@onready var bone_spear = preload("res://Scenes/bonespear.tscn")
@onready var muzzle = $Muzzle
@onready var sayings = $Sayings
var sayings_list = ["Raise", "Rally", "Once", "Recycle", "Bone"]
var target = null
var is_playing = false


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
				pick_saying()
				Spellhandler.bone_spear_cooldown = true
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "iron_maiden":
		Spellhandler.iron_maiden_cooldown = true
		pick_saying()
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "weaken":
		Spellhandler.weaken_cooldown = true
		pick_saying()
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "golem":
		Spellhandler.golem_summoned = true
		pick_saying()



func pick_saying():
	var saying = sayings_list.pick_random()
	match saying:
		"Raise":
			sayings.stream = load("res://assets/Music and sounds/Raise.wav")
		"Rally":
			sayings.stream = load("res://assets/Music and sounds/Rally.wav")
		"Recycle":
			sayings.stream = load("res://assets/Music and sounds/Recycle.wav")
		"Once":
			sayings.stream = load("res://assets/Music and sounds/Once Twice.wav")
		"Bone":
			sayings.stream = load("res://assets/Music and sounds/Bone.wav")
	if Currency.sound == true and is_playing == false:
		is_playing = true
		sayings.play()
		


func _on_sayings_finished():
	is_playing = false
