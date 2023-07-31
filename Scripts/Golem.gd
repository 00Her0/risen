extends Area2D

#stats for the base golem these will get buffed by a percentage from souls
@export var health = 100
@export var attack = 3
@export var damage_reduction = .99
@export var speed = 25
@export var life_steal = 0.01
var max_health
var soul_hp_mod = .05
var soul_attack_mod = .1
var soul_damage_reduction_mod = .99
var soul_life_steal_mod = .05

var targeted
var state = "inactive"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if state == "active":
		$"Hp Bar".value = health
		if targeted == null or targeted.state == 1:
			targeted = get_closest_enemy()
			if speed == 0:
				speed = 20
		if targeted != null:
			move(targeted, delta)
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		position.x = move_toward(position.x, 473, speed * delta)
		position.y = move_toward(position.y, 303, speed * delta)



func move(t, delta):
	if t is String: # sanity check
		return
	else:
		position.x = move_toward(position.x, t.position.x, (speed * 1.75) * delta)
		position.y = move_toward(position.y, t.position.y, speed * delta)
	if t.position.x < position.x:
		$AnimatedSprite2D.flip_h = true
		$"AnimatedSprite2D/Damage area/CollisionShape2D".position.x = -18
	else:
		$AnimatedSprite2D.flip_h = false
		$"AnimatedSprite2D/Damage area/CollisionShape2D".position.x = 18


func summon(souls_used):
	calc_stats(souls_used)
	$AnimatedSprite2D.visible = true
	$"Hp Bar".visible = true


func calc_stats(amount):
	max_health = health + (health*(soul_hp_mod*amount))
	$"Hp Bar".max_value = max_health
	$"Hp Bar".value = max_health
	health = max_health
	attack = attack + (attack*(soul_attack_mod*amount))
	damage_reduction = damage_reduction - ((soul_damage_reduction_mod*(soul_damage_reduction_mod*amount))/100)
	life_steal = life_steal + ((soul_life_steal_mod*amount)/10)
	
func take_damage(amount):
	health -= (amount * damage_reduction)
	if health < 0:
		queue_free()
		
func calc_damage():
	var temp_damage = attack
	if health < max_health:
		health += min(temp_damage * life_steal, (max_health - health))
	return temp_damage

func _on_attack_timer_timeout():
	if targeted != null:
		targeted.take_damage(calc_damage(), true)
		take_damage(5)
		$Attack_timer.start()

func sort_closest(a, b):
	return a.position < b.position

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	if !enemies.is_empty():
		enemies.sort_custom(sort_closest)
		return enemies.front()
	else: return null




func _on_damage_area_area_entered(area):
	if area.is_in_group("enemy") and area.state == 0 and state == "active":
		targeted = area
		$Attack_timer.start()
		speed = 0


