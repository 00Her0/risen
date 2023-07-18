extends Node

## this is an auto load that will be used to handle
## game state such as win/lose/pause

var state #this is the state the game is currently in



func _ready():
	state = "running"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause()
	if state == "win" or state == "lose":
		pause()
	# UI information that needs refreshed eveyr frame



func pause():
	if state == "running":
		state = "paused"
		get_tree().root.get_node("/root/Main/PauseMenu").visible = true
		get_tree().paused = true
	elif state == "lose" or state == "win":
		get_tree().root.get_node("/root/Main/PauseMenu").visible = true
		get_tree().paused = true


	
	
