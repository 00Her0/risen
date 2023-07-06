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



func _on_soulsteal_cooldown_timeout():
	Currency.add_soul(1)


func _on_raise_cooldown_timeout():
	pass # Replace with function body.


func _on_explode_cooldown_timeout():
	pass # Replace with function body.


func _on_soulstealbutton_pressed():
	soul_steal_cooldown.start()
	$Spellpanel/Infohbox/Soulstealbutton/CooldownShade.value = soul_steal_cooldown.time_left


func _on_raisebutton_pressed():
	pass # Replace with function body.


func _on_explodebutton_pressed():
	pass # Replace with function body.
