extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pop_up(where, title, text):
	
	$PanelContainer/BoxContainer/RichTextLabel.text = title
	$PanelContainer/BoxContainer/RichTextLabel2.text = text
	$Arrow.position = where
	if title == "dead enemy":
		Tutorial.popup_made()

func _on_button_pressed():
	Tutorial.popup_closed()
	queue_free()
