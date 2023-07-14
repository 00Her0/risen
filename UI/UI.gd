extends Control

@onready var soul_steal_cooldown = $Spellpanel/Infohbox/Soulstealbutton/SoulstealCooldown
@onready var raise_cooldown = $Spellpanel/Infohbox/Raisebutton/RaiseCooldown
@onready var explode_cooldown = $Spellpanel/Infohbox/Explodebutton/ExplodeCooldown
@onready var soul_count_label = $Spellpanel/Soulicon/Soulbar
@onready var soul_steal_shade = $Spellpanel/Infohbox/Soulstealbutton/CooldownShade
@onready var raise_shade = $Spellpanel/Infohbox/Raisebutton/CooldownShade
@onready var explode_shade = $Spellpanel/Infohbox/Explodebutton/CooldownShade
@onready var soul_bar = $Spellpanel/Soulicon/Soulbar
@onready var wall_hp = $Spellpanel/WallHPBar
@onready var wall_hp_label = $Spellpanel/WallHPBar/WallHpLabel
@onready var wave_label = $"Spellpanel/Wave label"
# Called when the node enters the scene tree for the first time.
func _ready():
	soul_steal_shade.max_value = soul_steal_cooldown.wait_time
	raise_shade.max_value = raise_cooldown.wait_time
	explode_shade.max_value = explode_cooldown.wait_time
	await get_tree().physics_frame
	wall_hp.max_value = Currency.wall_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wall_hp.value = Currency.wall_hp
	wall_hp_label.text = str(wall_hp.value) + " / " + str(wall_hp.max_value)
	soul_bar.value = Currency.souls
	soul_count_label.value = Currency.souls
	soul_steal_shade.value = soul_steal_cooldown.time_left
	raise_shade.value = raise_cooldown.time_left
	explode_shade.value = explode_cooldown.time_left
	if Currency.current_wave != 0 and Currency.current_wave != null:
		wave_label.text = "Wave: " + str(Currency.current_wave)
	# check if we need to start cooldown timers
	if Spellhandler.explode_cooldown and explode_cooldown.is_stopped():
		explode_cooldown.start()
	if Spellhandler.steal_cooldown and soul_steal_cooldown.is_stopped():
		soul_steal_cooldown.start()
	spell_cursor()

func _on_soulstealbutton_pressed():
	Spellhandler.current_spell = "steal"

func _on_soulsteal_cooldown_timeout():
	Spellhandler.steal_cooldown = false # reset cooldown

func _on_raisebutton_pressed():
	Spellhandler.current_spell = "raise"

func _on_explodebutton_pressed():
	Spellhandler.current_spell = "explode"

func _on_explode_cooldown_timeout():
	Spellhandler.explode_cooldown = false # reset cooldown

func spell_cursor(): # this code is a little messy but i don't really know how else to do it
	$Spellpanel/Infohbox/Soulstealbutton.position.y = 0
	$Spellpanel/Infohbox/Raisebutton.position.y = 0
	$Spellpanel/Infohbox/Explodebutton.position.y = 0
	match Spellhandler.current_spell:
		"steal":
			$Spellpanel/Infohbox/Soulstealbutton.position.y = -6
		"raise":
			$Spellpanel/Infohbox/Raisebutton.position.y = -6
		"explode":
			$Spellpanel/Infohbox/Explodebutton.position.y = -6


func _on_repair_button_pressed():
	Currency.repair_wall(wall_hp.max_value)


func _on_upgradewall_button_pressed():
	wall_hp.max_value += Currency.upgrade_wall() 


func _on_ultimate_dragon_button_2_pressed():
	pass # Replace with function body.
