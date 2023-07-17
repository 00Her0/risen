extends Control


@onready var win_lose_label = $Pause/WinLoseLabel

func _process(_delta):
	if Gamestate.state == "win":
		$Pause/Backbutton/Label.text = "Restart"
		win_lose_label.text = "Congratulations! you win!"
	elif Gamestate.state == "lose":
		$Pause/Backbutton/Label.text = "Restart"
		win_lose_label.text = "You lost...try again?"
	else:
		$Pause/Backbutton/Label.text = "Resume"
func _on_exitbutton_pressed():
	get_tree().quit()
	


func _on_backbutton_pressed():
	if Gamestate.state == "paused": #check if paused, if paused don't display win/lose message
		self.visible = false
		Gamestate.state = "running" #set game back to running
		get_tree().paused = false
	elif Gamestate.state == "lose" or Gamestate.state == "win": #display lose/win message 
		get_tree().paused = false
		Gamestate.state = "running"
		Gamestate.reset()
		get_tree().reload_current_scene()


func _on_mainmenubutton_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
