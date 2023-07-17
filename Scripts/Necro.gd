extends Sprite2D


@onready var bone_spear = preload("res://Scenes/bonespear.tscn")
@onready var muzzle = $Muzzle
var target = null


func shoot(target):
	look_at(target.global_position)
	var b = bone_spear.instantiate()
	add_child(b)
	b.start(muzzle.global_transform)

func _process(_delta):
	if Input.is_action_just_pressed("left click") and Spellhandler.current_spell == "bone_spear":
		shoot(Spellhandler.mouse_pos)
