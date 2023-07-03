extends Area2D


var speed = 2
var attack_range = 250
var attack_power = 5
var targeted
#$hit_cooldown.wait_time = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x < 1024 - attack_range:
		position.x += speed


func _on_sword_area_entered(area):
	$hit_cooldown.start()
	targeted = area

func _on_hit_cooldown_timeout():
	if targeted.broken == false:
		targeted.health -= attack_power
	else:
		attack_range = 0
