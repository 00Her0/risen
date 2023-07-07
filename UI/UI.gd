extends Control

@onready var soul_steal_cooldown = $Spellpanel/Infohbox/Soulstealbutton/SoulstealCooldown
@onready var raise_cooldown = $Spellpanel/Infohbox/Raisebutton/RaiseCooldown
@onready var explode_cooldown = $Spellpanel/Infohbox/Explodebutton/ExplodeCooldown
@onready var soul_count_label = $Spellpanel/Infohbox/Soullabel
@onready var soul_steal_shade = $Spellpanel/Infohbox/Soulstealbutton/CooldownShade
@onready var raise_shade = $Spellpanel/Infohbox/Raisebutton/CooldownShade
@onready var explode_shade = $Spellpanel/Infohbox/Explodebutton/CooldownShade
# Called when the node enters the scene tree for the first time.
func _ready():
	soul_steal_shade.max_value = soul_steal_cooldown.wait_time
	raise_shade.max_value = raise_cooldown.wait_time
	explode_shade.max_value = explode_cooldown.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	soul_count_label.text = str(Currency.souls)
	soul_steal_shade.value = soul_steal_cooldown.time_left
	raise_shade.value = raise_cooldown.time_left
	explode_shade.value = explode_cooldown.time_left
	# check of we need to start cooldown timers
	if Spellhandler.explode_cooldown and explode_cooldown.is_stopped():
		explode_cooldown.start()
	if Spellhandler.steal_cooldown and soul_steal_cooldown.is_stopped():
		soul_steal_cooldown.start()

func _on_soulstealbutton_pressed():
	Spellhandler.current_spell = "steal"

func _on_soulsteal_cooldown_timeout():
	Spellhandler.steal_cooldown = false # reset cooldown

func _on_raisebutton_pressed():
	pass # Replace with function body.

func _on_explodebutton_pressed():
	Spellhandler.current_spell = "explode"


func _on_explode_cooldown_timeout():
	Spellhandler.explode_cooldown = false # reset cooldown
