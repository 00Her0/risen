extends Node2D

@export var wall_1_health := 100
@export var wall_2_health := 100
@export var wall_3_health := 100
@onready var wall_1 = $"Wall_segment 1"
@onready var wall_2 = $"Wall_segment 2"
@onready var wall_3 = $"Wall_segment 3"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
