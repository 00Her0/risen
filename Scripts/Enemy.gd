extends Area2D


@export var speed: int
@export var attack_power: int
@export var health: int
@onready var anim
@onready var attack_delay = $hit_cooldown
@onready var undead_targetting = $"Undead_targeting system"
@onready var hp_bar = $"Hp bar"
@onready var explosion = preload("res://Scenes/explosion.tscn")
@onready var target = "none"
var unit_stats = {"Spearman": {"Health":100, "Attack": 5, "Speed": 20,},"Archer": {"Health":50, "Attack": 8, "Speed": 25,}, "Knight": {"Health":200, "Attack": 10, "Speed": 55,}, "Swordman": {"Health":150, "Attack": 5, "Speed": 10,}}
var unit_list = ["Spearman","Archer","Knight","Swordman"]
var unit_type
enum STATES {ALIVE, DEAD, RISEN}
var state = STATES.ALIVE
var targeted = Gamestate.wall.get_node("CollisionShape2D")
var wall
var status = "" # used for for damage calculations
var attack_status_multiplier = 1 # used to reduce damage dealt 
var defense_status_multiplier = 1
signal i_died(enemy_node)
var temp_attack_power
var temp_health
var temp_speed

func _ready():
	unit_type = unit_list.pick_random()
	assign_stats()
	temp_health = health
	hp_bar.max_value = health


func _process(delta):
	scale = Vector2(1.5-position.x/960, 1.5-position.x/960) # perspective effect
	hp_bar.value = health
	if state == STATES.ALIVE or state == STATES.RISEN:
		move(targeted, delta)
	check_status() # check for status effects
	if state == STATES.RISEN:
		if targeted is String:
			find_target()
		elif targeted.state == STATES.DEAD:
			print("hes down")
			attack_delay.stop()
			anim.play("Walk")
			targeted = "none"
			find_target()

func move(t, delta):
	if t is String: # sanity check
		find_target()
		return
	position.x = move_toward(position.x, t.position.x, speed * delta)
	position.y = move_toward(position.y, t.position.y, speed * delta)

func _on_hit_cooldown_timeout():
	if state != STATES.DEAD:
		if targeted.is_in_group("wall"):
			targeted.take_damage(attack_power * attack_status_multiplier)
		elif targeted.is_in_group("enemy"):
			targeted.take_damage(attack_power * attack_status_multiplier)

func _on_area_2d_area_entered(area):
	if area.is_in_group("wall") and state != STATES.RISEN:
		targeted = area
		anim.play("Attack")
		attack_delay.start()
		speed = 0
	elif area.is_in_group("enemy") and state == STATES.RISEN:
		targeted = area
		anim.play("Attack")
		attack_delay.start()
		speed = 0

func take_damage(damage):
	health -= damage * defense_status_multiplier
	
	if health <= 0:
		die()

#  function on death to add to a list of revivable
func die():
	#Currency.dead_list.append(self.position)
	if state == STATES.RISEN:
		queue_free()
	state = STATES.DEAD
	$Deathsound.play()
	hp_bar.visible = false
	remove_from_group("enemy")
	i_died.emit(self)
	anim.play("Dead")
	temp_attack_power = attack_power
	temp_speed = speed
	attack_power = 0

func raise():
	state = STATES.RISEN
	$Raisesound.play()
	$Raiseemitters/Raise.emitting = true
	undead_targetting.get_node("Undead collider").disabled = false
	$risen_damage.start()
	# Code here for recovering stats from before death
	hp_bar.visible = true
	anim.play("Walk")
	attack_power = temp_attack_power
	health = temp_health
	speed = temp_speed
	targeted = "none"
	find_target()

func find_target():
	print("finding target!!!!!!!!!!!!!!!!!!!!")
	for i in $"Undead_targeting system".get_overlapping_areas():
		if i.is_in_group("enemy"):
			if targeted is String:
				targeted = i
			elif position.distance_to(i.position) < position.distance_to(targeted.position):
				targeted = i
	if $Area2D.get_overlapping_areas().has(targeted):
		anim.play("Attack")
		attack_delay.start()
		speed = 0
	print(targeted)

func explode(): #spawn an explosion (then get rid of my body)
	$Explosionsound.play()
	var temp = explosion.instantiate()
	temp.position = position
	get_parent().add_child(temp)
	await $Explosionsound.finished
	queue_free()

func soul_particle(): # emite particles for soul steal and dissapear after!
	$Siphon.emitting = true
	await get_tree().create_timer(2.25).timeout
	queue_free()

func _on_button_pressed(): # if i'm dead tell spellhandler to do stuff
	if state == STATES.DEAD:
		Spellhandler.target(self) # tells spellhandler who i am
'''
func risen_loop(delta):
	if health <= 0:
		die()
	#if target is String: # if we dont have a target get one
	find_target()
	if target is String:
		pass
	elif state == "risen attack":
		if targeted.state == "dead":
			new_target()
		if $hit_cooldown.is_stopped():
			$hit_cooldown.start()
	else:
		if anim.animation != "Walk":
			anim.play("Walk")
		if target.position.x > self.position.x: # move toward target sorry for the bad code
			#little speed buff so they can catch up with enemies
			position.x += speed * 1.25 * delta
		else:
			position.x += -speed * 1.25 * delta
		if target.position.y > self.position.y:
			position.y += speed * 1.25 * delta
		else:
			position.y += -speed * 1.25 * delta


func _on_area_2d_area_exited(area):
	if area.is_in_group("enemy") and state == "risen attack":
		new_target()

func new_target():
	state = "risen"
	target = "none"
	anim.play("Walk")
	$hit_cooldown.stop()
'''
func _on_risen_damage_timeout():
	health -= 5

func assign_stats(): #Assign stats for the unit and swap sprites for the appropriate unit
	health = unit_stats[unit_type]["Health"]
	attack_power = unit_stats[unit_type]["Attack"]
	speed = unit_stats[unit_type]["Speed"]
	get_node(unit_type).visible = true
	anim = get_node(unit_type)
	if unit_type == "Archer":
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/Archer_attack.disabled = false

func _on_area_entered(area):
	if "Fireball" in area.name and state == STATES.ALIVE:
		$Fireballhit.emitting = true

func check_status():
	if "w" in status: # look for weaken which lowers damage output
		attack_status_multiplier = 0.75
	else:
		attack_status_multiplier = 1
	if "i" in status: #look for iron maiden status to double damage taken
		defense_status_multiplier = 2
	else:
		defense_status_multiplier = 1

func apply_status(type):
	match type:
		"iron_maiden":
			if "i" not in status:
				status += "i"
				$Ironmaidenemitter.emitting = true
				$Ironmaidenemitter/IronmaidenTimer.start()
		"weaken":
			if "w" not in status:
				status += "w"
				$Weakenemitter.emitting = true
				$Weakenemitter/WeakenTimer.start()

func _on_weaken_timer_timeout():
	$Weakenemitter.emitting = false
	status.replace("w","")

func _on_ironmaiden_timer_timeout():
	$Ironmaidenemitter.emitting = false
	status.replace("i","")
