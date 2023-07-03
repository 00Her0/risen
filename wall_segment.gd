extends Area2D

var health = 100
var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		broken = true
		$AnimatedSprite2D.visible = false
