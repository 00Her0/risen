extends Control

#these have been updated to new locations for new UI
@onready var raise_cooldown = $TabContainer/Soulspellpanel/HBoxContainer/Raisebutton/RaiseCooldown
@onready var explode_cooldown = $TabContainer/Soulspellpanel/HBoxContainer/Explodebutton/ExplodeCooldown
@onready var bone_spear_cooldown = $TabContainer/Necrospellpanel/HBoxContainer/Bonespearbutton/Bonespearcooldown
@onready var iron_maiden_cooldown = $TabContainer/Necrospellpanel/HBoxContainer/Ironmaindenbutton/Ironmaidencooldown
@onready var weaken_cooldown = $TabContainer/Necrospellpanel/HBoxContainer/Weakenbutton/Weakencooldown

@onready var raise_shade = $TabContainer/Soulspellpanel/HBoxContainer/Raisebutton/CooldownShade
@onready var explode_shade = $TabContainer/Soulspellpanel/HBoxContainer/Explodebutton/CooldownShade
@onready var bone_spear_shade = $TabContainer/Necrospellpanel/HBoxContainer/Bonespearbutton/CooldownShade
@onready var iron_maiden_shade = $TabContainer/Necrospellpanel/HBoxContainer/Ironmaindenbutton/CooldownShade
@onready var weaken_shade = $TabContainer/Necrospellpanel/HBoxContainer/Weakenbutton/CooldownShade
@onready var golem_shade = $TabContainer/Soulspellpanel/HBoxContainer/Golembutton/CooldownShade
@onready var wall_hp = $Healthprogressbar
@onready var soul_count = $SoulsProgressBar

@onready var spell_aoe = preload("res://Scenes/spell_aoe.tscn")
var spell_aoe_node

#NEW UI SETUP
#tab container setup
@onready var tab_bar = $TabBar
@onready var tab_container = $TabContainer
var current_tab 

#wavecounter and time to next wave setup
@onready var wave_label = $"Wave label"
@onready var time_to_next_wave = $"Wave label/Timetonextwave"
@onready var next_wave_timer = $"Wave label/Timetonextwave/Wavetimer"

# Called when the node enters the scene tree for the first time.
func _ready():
	raise_shade.max_value = raise_cooldown.wait_time
	explode_shade.max_value = explode_cooldown.wait_time
	bone_spear_shade.max_value = bone_spear_cooldown.wait_time
	iron_maiden_shade.max_value = iron_maiden_cooldown.wait_time
	weaken_shade.max_value = weaken_cooldown.wait_time
	wall_hp.max_value = Currency.wall_max_hp
	wall_hp.value = Currency.wall_hp
	soul_count.max_value = 7
	soul_count.value = Currency.souls
	$"Wave label/Timetonextwave/Wavetimer".start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	raise_shade.value = raise_cooldown.time_left
	explode_shade.value = explode_cooldown.time_left
	bone_spear_shade.value = bone_spear_cooldown.time_left
	iron_maiden_shade.value = iron_maiden_cooldown.time_left
	weaken_shade.value = weaken_cooldown.time_left
	wall_hp.value = Currency.wall_hp
	soul_count.value = Currency.souls
	if Currency.current_wave != 0 and Currency.current_wave != null:
		wave_label.text = "Wave: " + str(Currency.current_wave)
	# check if we need to start cooldown timers
	if Spellhandler.explode_cooldown and explode_cooldown.is_stopped():
		explode_cooldown.start()
	if Spellhandler.raise_cooldown and raise_cooldown.is_stopped():
		raise_cooldown.start()
	if Spellhandler.bone_spear_cooldown and bone_spear_cooldown.is_stopped():
		bone_spear_cooldown.start()
	if Spellhandler.iron_maiden_cooldown and iron_maiden_cooldown.is_stopped():
		iron_maiden_cooldown.start()
	if Spellhandler.weaken_cooldown and weaken_cooldown.is_stopped():
		weaken_cooldown.start()
	#New GUI wave timer
	time_to_next_wave.text = "Next wave in: " + str(round(next_wave_timer.time_left))

#	spell_cursor()
	#code to handle moving the spell area indicator
	if Spellhandler.current_spell == "iron_maiden" or Spellhandler.current_spell == "weaken":
		if spell_aoe_node != null:
			spell_aoe_node.position = Vector2(Spellhandler.mouse_pos.x, Spellhandler.mouse_pos.y)
			if Input.is_action_just_pressed("left click"):
				spell_aoe_node.cast()
	else:
		if spell_aoe_node != null:
			spell_aoe_node.queue_free()

	# Hot keys!!
	if Input.is_action_just_pressed("raise"):
		Spellhandler.current_spell = "raise"
	if Input.is_action_just_pressed("siphon"):
		Spellhandler.current_spell = "steal"
	if Input.is_action_just_pressed("explode"):
		Spellhandler.current_spell = "explode"
	if Input.is_action_just_pressed("bone_spear"):
		Spellhandler.current_spell = "bone_spear"
	if Input.is_action_just_pressed("iron_maiden"):
		Spellhandler.current_spell = "iron_maiden"
		show_spell_aoe("iron_maiden")
	if Input.is_action_just_pressed("weaken"):
		Spellhandler.current_spell = "weaken"
		show_spell_aoe("weaken")
	if Input.is_action_just_pressed("golem"):
		Spellhandler.current_spell = "golem"



func _on_raisebutton_pressed():
	if  raise_cooldown.is_stopped():
		Spellhandler.current_spell = "raise"

func _on_explodebutton_pressed():
	if explode_cooldown.is_stopped():
		Spellhandler.current_spell = "explode"

func _on_explode_cooldown_timeout():
	Spellhandler.explode_cooldown = false # reset cooldown


func _on_repair_button_pressed():
	Currency.repair_wall(wall_hp.max_value)


func _on_upgradewall_button_pressed():
	wall_hp.max_value += Currency.upgrade_wall() 


func _on_ultimate_dragon_button_2_pressed():
	Spellhandler.current_spell = "ultimate_dragon"


func _on_raise_cooldown_timeout():
	Spellhandler.raise_cooldown = false


func _on_bonespearbutton_pressed():
	if bone_spear_cooldown.is_stopped():
		Spellhandler.current_spell = "bone_spear"

func _on_ironmaindenbutton_pressed():
	if iron_maiden_cooldown.is_stopped():
		show_spell_aoe("iron_maiden")

func _on_golembutton_pressed():
	Spellhandler.current_spell = "golem"

func _on_bonespearcooldown_timeout():
	Spellhandler.bone_spear_cooldown = false

func _on_ironmaidencooldown_timeout():
	Spellhandler.iron_maiden_cooldown = false

func _on_weakenbutton_pressed():
	if weaken_cooldown.is_stopped():
		show_spell_aoe("weaken")

func show_spell_aoe(spell): #shows area where spell with effect
	if spell_aoe_node != null:
		spell_aoe_node.queue_free()
	Spellhandler.current_spell = spell
	var sp = spell_aoe.instantiate()
	sp.position = Spellhandler.mouse_pos
	add_child(sp)
	spell_aoe_node = get_node("Spell aoe")

func _on_weakencooldown_timeout():
	Spellhandler.weaken_cooldown = false


func _on_tab_bar_tab_clicked(tab):
	if tab != current_tab:
		current_tab = tab
		tab_container.current_tab = current_tab


func _on_wavetimer_timeout():
	next_wave_timer.start(Currency.time_to_next_wave)
