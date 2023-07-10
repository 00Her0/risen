extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$AudioStreamPlayer.playing = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_options_button_pressed():
	if $Main.visible == true:
		$Main.visible = false
	elif $Credit.visible == true:
		$Credit.visible = false
	$Options.visible = true


func _on_credits_button_pressed():
	if $Main.visible == true:
		$Main.visible = false
	elif $Options.visible == true:
		$Options.visible = false
	$Credit.visible = true


func _on_exit_button_pressed():
	get_tree().quit()


func _on_mutebutton_pressed():
	if $AudioStreamPlayer.playing == true:
		$AudioStreamPlayer.playing = false
	else:
		$AudioStreamPlayer.playing = true


func _on_mute_sound_button_pressed():
	pass # Replace with function body.


func _on_options_back_button_pressed():
	if $Options.visible == true:
		$Options.visible = false
	$Main.visible = true


func _on_credits_back_button_pressed():
	if $Credit.visible == true:
		$Credit.visible = false
	$Main.visible = true
