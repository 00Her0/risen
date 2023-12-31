extends Area2D


@export var speed = 350
@export var damage := 10
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(transform):
	global_transform = transform
	velocity = transform.x * speed

func _physics_process(delta):
	velocity += acceleration * delta
	clamp(velocity,Vector2.ZERO,Vector2(speed,speed))
	rotation = velocity.angle()
	position += velocity * delta

func _on_area_entered(area):
	if area.has_method("take_damage") and area.name != "Wall":
		area.take_damage(damage)
