extends Node

enum {harvest, spell}
var state = harvest

func popup_made():
	state += 1

func _process(delta):
	match state:
		spell:
			popup_made()
			await get_tree().create_timer(10).timeout
			var popup = Spellhandler.make_popup(Vector2(25,25), "Spells", "Click on a spell to select it, then click on the battlefield to use it.")
