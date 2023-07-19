extends Area2D

var damage = 100

func _ready():
	$GPUParticles2D.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_entered(area): # do damage
	if area.is_in_group("enemy"):
		area.take_damage(damage)


func _on_lifetime_timeout(): # delete after 1 second
	queue_free()
