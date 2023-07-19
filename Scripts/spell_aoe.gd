extends Area2D


@onready var spell = Spellhandler.current_spell

func cast():
	var effected = get_overlapping_areas()
	for unit in effected:
		if  unit.is_in_group("enemy") and unit.state == 0:
			unit.apply_status(spell)
	queue_free()
