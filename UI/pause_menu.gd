extends Control


@onready var win_lose_label = $Pause/WinLoseLabel

func _process(_delta):
	if Gamestate.state == "win":
		$Pause/Exitbutton/Label.text = "Restart"
		win_lose_label.text = "Congratulations! you win!"
	elif Gamestate.state == "lose":
		$Pause/Exitbutton/Label.text = "Restart"
		win_lose_label.text = "You lost...try again?"
	else:
		$Pause/Exitbutton/Label.text = "Exit"
func _on_exitbutton_pressed():
	if Gamestate.state == "paused": # Quit game if game is paused
		get_tree().quit()
	


func _on_backbutton_pressed():
	if Gamestate.state == "paused": #check if paused, if paused don't display win/lose message
		self.visible = false
		Gamestate.state = "running" #set game back to running
		get_tree().paused = false
	elif Gamestate.state == "lose": #display lose message and change buttons to retry and exit
		
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		get_tree().paused = false
	elif Gamestate.state == "win": #display win message and change buttons to retry and exit
		
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		get_tree().paused = false


func _on_mainmenubutton_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
