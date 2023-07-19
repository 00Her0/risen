extends Node

var state
var wall
# Called when the node enters the scene tree for the first time.
func _ready():
	state = "running"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause()
	if state == "win" or state == "lose":
		pause()


func pause():
	if state == "running":
		state = "paused"
		get_tree().root.get_node("/root/Main/PauseMenu").visible = true
		get_tree().paused = true
	elif state == "lose" or state == "win":
		get_tree().root.get_node("/root/Main/PauseMenu").visible = true
		get_tree().paused = true

func reset():
	Currency.souls = 0
	Currency.soul_list = []
	Currency.wall_hp = 0
	Currency.wall_repair_bool = false
	Currency.wall_upgrade_bool = false
	Currency.wave = 0
	
	
