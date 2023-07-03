extends Area2D

@export var rotation_speed = PI
@export var cooldown = 0.5
var target_list = []
var fireball_scene = preload("res://Scenes/fireball.tscn")
@onready var muzzle = $Dragon/Muzzle
var target = null
var can_shoot = true

func shoot():
	if can_shoot:
		var f = fireball_scene.instantiate()
		get_parent().add_child(f)
		f.start(muzzle.global_transform)
		can_shoot = false
		await get_tree().create_timer(cooldown).timeout
		can_shoot = true
		
func _process(_delta):
	if target:
		$Dragon.look_at(target.global_position)
		shoot()


func _on_targetting_system_area_entered(area):
	if area.name == "Enemy" && area.state != "dead":
		add_target(area)
		target = area
		

#add target to list and connect targets death signal
func add_target(enemy):
	target_list.append(enemy)
	enemy.i_died.connect(manage_targets)

# Keep list sorted by nearest to wall and remove a target if it dies
func manage_targets():
	if !target_list.is_empty():
		for target in target_list:
			print(target.position)
