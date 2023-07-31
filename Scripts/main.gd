extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Currency.music == true:
		$AudioStreamPlayer.play()
	Gamestate.playing = true
