extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.playing = true

func _process(delta):
	if Currency.sound == false:
		$Options/MuteSoundButton/Label.text = "Unmute Sound"
	elif Currency.sound == true:
		$Options/MuteSoundButton/Label.text = "Mute Sound"
	if Currency.music == true:
		$Options/Mutebutton/Label.text = "Mute Music"
	elif Currency.music == false:
		$Options/Mutebutton/Label.text = "Unmute Music"

func _on_start_button_pressed():
	$AudioStreamPlayer.playing = false
	if Currency.sound == true:
		$Start.play()
		await $Start.finished
	if get_tree().paused == true:
		if Gamestate.state != "running":
			get_tree().paused = false
			Gamestate.state = "running"
	get_tree().change_scene_to_file("res://main.tscn")


func _on_options_button_pressed():
	if Currency.sound == true:
		$Click.play()
	if $Main.visible == true:
		$Main.visible = false
	elif $Credit.visible == true:
		$Credit.visible = false
	$Options.visible = true


func _on_credits_button_pressed():
	if Currency.sound == true:
		$Click.play()
	if $Main.visible == true:
		$Main.visible = false
	elif $Options.visible == true:
		$Options.visible = false
	$Credit.visible = true


func _on_exit_button_pressed():
	if Currency.sound == true:
		$Click.play()
	get_tree().quit()


func _on_mutebutton_pressed():
	if Currency.sound == true:
		$Click.play()
	if Currency.music == true:
		Currency.music = false
	elif Currency.music == false:
		Currency.music = true


func _on_mute_sound_button_pressed():
	if Currency.sound == true:
		$Click.play()
		Currency.sound = false
	elif Currency.sound == false:
		Currency.sound = true


func _on_options_back_button_pressed():
	if Currency.sound == true:
		$Click.play()
	if $Options.visible == true:
		$Options.visible = false
	$Main.visible = true


func _on_credits_back_button_pressed():
	if Currency.sound == true:
		$Click.play()
	if $Credit.visible == true:
		$Credit.visible = false
	$Main.visible = true


func _on_start_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_credits_back_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_options_back_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_credits_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_mute_sound_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_mutebutton_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_exit_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()


func _on_options_button_mouse_entered():
	if Currency.sound == true:
		$Hover.play()
