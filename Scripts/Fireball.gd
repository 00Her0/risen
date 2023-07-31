extends Area2D

@export var speed = 350
@export var damage := 10
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(transform):
	$Sprite2D.set_self_modulate(Color(0.09,1,0.08,1))
	$Trailemitter.set_self_modulate(Color(0.09,1,0.08,1))
	global_transform = transform
	velocity = transform.x * speed

func _physics_process(delta):
	velocity += acceleration * delta
	clamp(velocity,Vector2.ZERO,Vector2(speed,speed))
	rotation = velocity.angle()
	position += velocity * delta


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		$Explode.play()
		area.take_damage(damage)
		queue_free()


func _on_lifetime_timeout():
	queue_free()
