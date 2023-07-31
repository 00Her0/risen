extends Node

var state
var wall
var difficulty : float = 2.5
var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	state = "running"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause()
	if state == "win" or state == "lose":
		pause()
	if state == "10th":
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
#	elif state == "10th":
#		get_tree().paused = true
#		var popup = Spellhandler.make_popup(Vector2(-30,-70), "You've made it this far", "Do you think you can make it another 10 waves??")

	
	
