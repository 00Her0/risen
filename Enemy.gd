extends Area2D


@export var speed = 20
@export var attack_range = 250
@export var attack_power = 5
@export var health := 100
var targeted
@onready var anim = $AnimatedSprite2D
@onready var attack_delay = $hit_cooldown
@onready var undead_targetting = $"Undead_targeting system"
var state
signal i_died(Node2D)
var temp_attack_power
var temp_health := health
func _ready():
	state = "attack"



func _process(delta):
	if position.x < 960:
		position.x += speed * delta
	if Input.is_action_just_pressed("ui_accept"):
		speed = 0



func _on_hit_cooldown_timeout():
	if state != "dead":
		if targeted.broken == false:
			targeted.take_damage(attack_power)
		else:
			attack_range = 0


func _on_area_2d_area_entered(area):
	if area.is_in_group("wall"):
		targeted = area
		anim.play("Attack")
		attack_delay.start()
		speed = 0

#
func take_damage(damage):
	if health >= damage:
		health -= damage
		if health <= 0:
			die()

#  function on death to add to a list of revivable
func die():
	#Currency.dead_list.append(self.position)
	state = "dead"
	Currency.add_dead(self)
	i_died.emit(self)
	anim.play("Dead")
	temp_attack_power = attack_power
	attack_power = 0
	speed = 0
	rotation = 90


#Risen state code here
func raise():
	state = "risen"
	undead_targetting.disabled = false
	# Code here for recovering stats from before death
	
	
	# slow speed going up, they will target the nearest enemy until they die or the
	#life timer ends
	speed = -20
	
	
func find_target():
	var target_list = []
	var possible_target_list = undead_targetting.get_overlapping_areas()
	for target in possible_target_list:
		if "enemy" in target.name:
			target_list.append(target)
	
	
