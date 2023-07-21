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

#	elif !target:
#		print(target_list)
#		target = find_closest_target(target_list)


func _on_targetting_system_area_entered(area):
	if area.is_in_group("enemy"):
		add_target(area)
		if target:
			if area.position.x > target.position.x:
				target = area
		else:
			target = area

#add target to list and connect targets death signal
func add_target(enemy):
	target_list.append(enemy)
	if enemy.has_signal("i_died"):
		enemy.i_died.connect(remove_target)


# remove targets on death
func remove_target(enemy):
	if target_list.has(enemy):
		if enemy.state == 1:
			target_list.remove_at(target_list.find(enemy))
			if !target_list.is_empty():
				target = target_list.front()
			else:
				target = null
