extends Area2D


@export var speed = 20
@export var attack_power = 5
@export var health := 100
var targeted
@onready var anim = $AnimatedSprite2D
@onready var attack_delay = $hit_cooldown
@onready var undead_targetting = $"Undead_targeting system"
@onready var hp_bar = $"Hp bar"
@onready var explosion = preload("res://Scenes/explosion.tscn")
@onready var target = "none"
var state
var wall
signal i_died(enemy_node)
var temp_attack_power
var temp_health := health
func _ready():
	state = "move"
	hp_bar.max_value = health


func _process(delta):
	scale = Vector2(1.5-position.x/960, 1.5-position.x/960)
	hp_bar.value = health
	if state == "move":
		position.y -= (speed / 3) * delta
		position.x += speed * delta
	elif state == "risen" or state == "risen attack":
		risen_loop(delta)
	elif state == "attack": # attack is the state when touching wall
		$hit_cooldown.start()



func _on_hit_cooldown_timeout():
	if state != "dead":
		if targeted.broken == false:
			targeted.take_damage(attack_power)


func _on_area_2d_area_entered(area):
	if area.is_in_group("wall"):
		targeted = area
		state = "attack"
		anim.play("Attack")
		attack_delay.start()
		speed = 0
	elif area.is_in_group("enemy") and state == "risen":
		print("boys we got emmmm")
		state = "risen attack"
		targeted = area

#
func take_damage(damage):
	#if health >= damage: i removed this, it didn't seem right -reed
	health -= damage
	if health <= 0:
		die()

#  function on death to add to a list of revivable
func die():
	#Currency.dead_list.append(self.position)
	state = "dead"
	hp_bar.visible = false
	remove_from_group("enemy") # for dragon targetting hopefully this won't break anything
	Currency.add_dead(self)
	i_died.emit(self)
	anim.play("Dead")
	temp_attack_power = attack_power
	attack_power = 0
	speed = 0



#Risen state code here
func raise():
	state = "risen"
	undead_targetting.get_node("Undead collider").disabled = false
	# Code here for recovering stats from before death
	hp_bar.visible = true
	anim.play("Walk")
	attack_power = temp_attack_power
	
	# slow speed going up, they will target the nearest enemy until they die or the
	# life timer ends
	speed = -20
	
	
func find_target():
	var target_list = []
	var possible_target_list = undead_targetting.get_overlapping_areas()
	for i in possible_target_list:
		if i.is_in_group("enemy"):
			target_list.append(i)
	for i in target_list:
		if target is String:
			target = i
		else:
			if i.position.distance_to(self.position) <= target.position.distance_to(self.position):
				target = i
	return target

func explode(): #spawn an explosion (then get rid of my body)
	var temp = explosion.instantiate()
	temp.position = position
	get_parent().add_child(temp)
	queue_free()

func _on_button_pressed(): # if i'm dead tell spellhandler to do stuff
	if state == "dead":
		Spellhandler.target(self) # tells spellhandler who i am

func risen_loop(delta):
	if target is String: # if we dont have a target get one
		find_target()
	elif state == "risen attack":
		print("RISEN ATTACKKKKKKKK")
		targeted.take_damage(attack_power)
		if targeted.state == "dead":
			state = "risen"
	else:
		if target.position.x > self.position.x: # move toward target sorry for the bad code
			position.x += 20 * delta
		else:
			position.x += -20 * delta
		if target.position.y > self.position.y:
			position.y += 20 * delta
		else:
			position.y += -20 * delta
