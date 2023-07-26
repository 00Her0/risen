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
var unit_stats = {"Spearman": {"Health":100, "Attack": 5, "Speed": 15,},"Archer": {"Health":50, "Attack": 8, "Speed": 25,}, "Knight": {"Health":100, "Attack": 10, "Speed": 30,}, "Swordman": {"Health":150, "Attack": 5, "Speed": 5,}}
var unit_list = ["Spearman","Archer","Knight","Swordman"]
var unit_type
enum STATES {ALIVE, DEAD, RISEN}
var state = STATES.ALIVE
var targeted = Gamestate.wall.get_node("CollisionShape2D")
var wall
var being_siphoned = false
var status = "" # used for for damage calculations
var attack_status_multiplier = 1 # used to reduce damage dealt 
var defense_status_multiplier = 1
signal i_died(enemy_node)
var temp_attack_power
var temp_health
var temp_speed
var popup

func _ready():
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

			attack_delay.stop()
			anim.play("Walk")
			targeted = "none"
			find_target()

func set_type(unit):
	print(unit)
	match unit:
		"SP":
			unit_type = "Spearman"
		"SW":
			unit_type = "Swordman"
		"KN":
			unit_type = "Knight"
		"AR":
			unit_type = "Archer"
		_:
			unit_type = "Spearman"

func move(t, delta):
	if t is String: # sanity check
		return
	position.x = move_toward(position.x, t.position.x, (speed * 1.75) * delta)
	if state == STATES.ALIVE:
		position.y -= (speed) * delta
	else:
		position.y = move_toward(position.y, t.position.y, speed * delta)

func _on_hit_cooldown_timeout():
	if state != STATES.DEAD:
		if targeted.is_in_group("wall"):
			targeted.take_damage(attack_power * attack_status_multiplier)
		elif targeted.is_in_group("enemy"):
			targeted.take_damage(attack_power * attack_status_multiplier, true)

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

func take_damage(damage, risen_state := false):
	health -= damage * defense_status_multiplier

	if risen_state:
		anim.play("Attack")
		attack_delay.start()
		speed = 0
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
	if $Weakenemitter.emitting == true:
		$Weakenemitter.emitting = false
	if $Ironmaidenemitter.emitting == true:
		$Ironmaidenemitter.emitting = false
	temp_attack_power = attack_power
	temp_speed = speed
	attack_power = 0
	if Tutorial.state == 0:
		popup = Spellhandler.make_popup(position, "dead enemy", "right click to harvest their soul")

func raise():
	state = STATES.RISEN
	modulate_sprite()
	$Raisesound.play()
	$Raiseemitters/Raise.emitting = true
	undead_targetting.get_node("Undead collider").disabled = false
	$risen_damage.start()
	# Code here for recovering stats from before death
	hp_bar.visible = true
	anim.play("Walk")
	attack_power = temp_attack_power
	health = temp_health
	speed = 100
	targeted = "none"
	find_target()

func find_target():
	speed = temp_speed
	for i in $"Undead_targeting system".get_overlapping_areas():
		if i.is_in_group("enemy") and i != self:
			if targeted is String:
				targeted = i
			elif position.distance_to(i.position) < position.distance_to(targeted.position):
				targeted = i
	for i in  $Area2D.get_overlapping_areas():
		if not targeted is String:
			if i == targeted:
				anim.play("Attack")
				attack_delay.start()
				speed = 0


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

func _on_risen_damage_timeout():
	health -= 5
	if health <= 0:
		queue_free()

func assign_stats(): #Assign stats for the unit and swap sprites for the appropriate unit
	health = difficulty_mod(unit_stats[unit_type]["Health"])
	attack_power = difficulty_mod(unit_stats[unit_type]["Attack"])
	speed = unit_stats[unit_type]["Speed"]
	get_node(unit_type).visible = true
	anim = get_node(unit_type)
	if unit_type == "Archer":
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/Archer_attack.disabled = false

func difficulty_mod(stat, mod := Gamestate.difficulty):
	var temp_stat = ((stat * mod)*0.25)
	print(temp_stat)
	return temp_stat

func _on_area_entered(area):
	if "Fireball" in area.name and state == STATES.ALIVE:
		$Fireballhit.emitting = true
	if "Enemy" in area.get_parent().name:
		pass

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


func _on_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if state == STATES.DEAD:
					Spellhandler.target(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if state == STATES.DEAD:
					if !being_siphoned:
						being_siphoned = true
						Spellhandler.soul_siphon(self)
						

func modulate_sprite():
	match unit_type:
		"Knight":
			$Knight.set_self_modulate(Color(0.09,1,0.08,1))
		"Swordman":
			$Swordman.set_self_modulate(Color(0.09,1,0.08,1))
		"Archer":
			$Archer.set_self_modulate(Color(0.09,1,0.08,1))
		"Spearman":
			$Spearman.set_self_modulate(Color(0.09,1,0.08,1))
