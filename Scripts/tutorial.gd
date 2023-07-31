extends Node

enum {spell, harvest, soul, lair, health, souls}
var state = spell
var popup_open = false

func popup_made():
	state += 1
	popup_open = true

func popup_closed():
	popup_open = false
	get_tree().paused = false

func _process(delta):
	if popup_open == false and Gamestate.playing:
		match state:
			spell:
				popup_made()
				await get_tree().create_timer(10).timeout
				get_tree().paused = true
				var popup = Spellhandler.make_popup(Vector2(30,70), "Spells", "This tab has spells, which are abilities that can be used as many times as you want and with no cost other than their cooldown. Hover over one of them to read more.")
			soul:
				popup_made()
				await get_tree().create_timer(10).timeout
				get_tree().paused = true
				var popup = Spellhandler.make_popup(Vector2(130,70), "Soul Abilities", "This tab has soul abilities, which are abilities that cost souls. Hover over one of them to read more.")
			lair:
				popup_made()
				await get_tree().create_timer(10).timeout
				get_tree().paused = true
				var popup = Spellhandler.make_popup(Vector2(230,70), "Lair Abilities", "This tab has lair abilities, which are abilities that don't cost anything but can only be used once. Hover over one of them to read more.")
			health:
				popup_made()
				await get_tree().create_timer(10).timeout
				get_tree().paused = true
				var popup = Spellhandler.make_popup(Vector2(12,116), "Health", "This bar shows the health of your fortress. Don't let it run out! You can restore it once by using a lair ability.")
			souls:
				popup_made()
				await get_tree().create_timer(10).timeout
				get_tree().paused = true
				var popup = Spellhandler.make_popup(Vector2(12,140), "Souls", "This bar shows how many souls you have. Right click fallen enemies to get more.")
