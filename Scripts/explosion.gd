extends Area2D

var damage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area): # do damage
	if area.is_in_group("enemy"):
		area.take_damage(damage)


func _on_lifetime_timeout(): # delete after 1 second
	queue_free()
