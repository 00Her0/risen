extends Control

@onready var soul_steal_cooldown = $Spellpanel/Infohbox/Soulstealbutton/SoulstealCooldown
@onready var raise_cooldown = $Spellpanel/Infohbox/Raisebutton/RaiseCooldown
@onready var explode_cooldown = $Spellpanel/Infohbox/Explodebutton/ExplodeCooldown
@onready var bone_spear_cooldown = $Spellpanel/Infohbox/Bonespearbutton/Bonespearcooldown
@onready var iron_maiden_cooldown = $Spellpanel/Infohbox/Ironmaindenbutton/Ironmaidencooldown
@onready var weaken_cooldown = $Spellpanel/Infohbox/Weakenbutton/Weakencooldown

@onready var soul_steal_shade = $Spellpanel/Infohbox/Soulstealbutton/CooldownShade
@onready var raise_shade = $Spellpanel/Infohbox/Raisebutton/CooldownShade
@onready var explode_shade = $Spellpanel/Infohbox/Explodebutton/CooldownShade
@onready var bone_spear_shade = $Spellpanel/Infohbox/Bonespearbutton/CooldownShade
@onready var iron_maiden_shade = $Spellpanel/Infohbox/Ironmaindenbutton/CooldownShade
@onready var weaken_shade = $Spellpanel/Infohbox/Weakenbutton/CooldownShade
@onready var golem_shade = $Spellpanel/Infohbox/Golembutton/CooldownShade

@onready var wall_hp = $Spellpanel/WallHPBar
@onready var wall_hp_label = $Spellpanel/WallHPBar/WallHpLabel
@onready var wave_label = $"Spellpanel/Wave label"
@onready var soul_count = $Spellpanel/Soul_counter

@onready var spell_aoe = preload("res://Scenes/spell_aoe.tscn")
var spell_aoe_node
var stretch
# Called when the node enters the scene tree for the first time.
func _ready():
	soul_steal_shade.max_value = soul_steal_cooldown.wait_time
	raise_shade.max_value = raise_cooldown.wait_time
	explode_shade.max_value = explode_cooldown.wait_time
	bone_spear_shade.max_value = bone_spear_cooldown.wait_time
	iron_maiden_shade.max_value = iron_maiden_cooldown.wait_time
	weaken_shade.max_value = weaken_cooldown.wait_time
	
	await get_tree().physics_frame
	wall_hp.max_value = Currency.wall_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wall_hp.value = Currency.wall_hp
	wall_hp_label.text = str(wall_hp.value) + " / " + str(wall_hp.max_value)
	soul_steal_shade.value = soul_steal_cooldown.time_left
	raise_shade.value = raise_cooldown.time_left
	explode_shade.value = explode_cooldown.time_left
	bone_spear_shade.value = bone_spear_cooldown.time_left
	iron_maiden_shade.value = iron_maiden_cooldown.time_left
	weaken_shade.value = weaken_cooldown.time_left
	if Currency.current_wave != 0 and Currency.current_wave != null:
		wave_label.text = "Wave: " + str(Currency.current_wave)
	# check if we need to start cooldown timers
	if Spellhandler.explode_cooldown and explode_cooldown.is_stopped():
		explode_cooldown.start()
	if Spellhandler.steal_cooldown and soul_steal_cooldown.is_stopped():
		soul_steal_cooldown.start()
	if Spellhandler.raise_cooldown and raise_cooldown.is_stopped():
		raise_cooldown.start()
	if Spellhandler.bone_spear_cooldown and bone_spear_cooldown.is_stopped():
		bone_spear_cooldown.start()
	if Spellhandler.iron_maiden_cooldown and iron_maiden_cooldown.is_stopped():
		iron_maiden_cooldown.start()
	if Spellhandler.weaken_cooldown and weaken_cooldown.is_stopped():
		weaken_cooldown.start()
	print($Spellpanel/Infohbox/Ironmaindenbutton/Ironmaidencooldown.time_left)

	spell_cursor()
	#Change soul bar dependant on current amount of souls
	stretch = (32 * Currency.souls)
	soul_count.size = Vector2(stretch, 32)
	
	#code to handle moving the spell area indicator
	if Spellhandler.current_spell == "iron_maiden" or Spellhandler.current_spell == "weaken":
		if spell_aoe_node != null:
			spell_aoe_node.position = Vector2(Spellhandler.mouse_pos.x, Spellhandler.mouse_pos.y - 505)
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
	$Spellpanel/Infohbox/Bonespearbutton.position.y = 0
	$Spellpanel/Infohbox/Ironmaindenbutton.position.y = 0
	$Spellpanel/Infohbox/Weakenbutton.position.y = 0
	match Spellhandler.current_spell:
		"steal":
			$Spellpanel/Infohbox/Soulstealbutton.position.y = -6
		"raise":
			$Spellpanel/Infohbox/Raisebutton.position.y = -6
		"explode":
			$Spellpanel/Infohbox/Explodebutton.position.y = -6
		"bone_spear":
			$Spellpanel/Infohbox/Bonespearbutton.position.y = -6
		"iron_maiden":
			$Spellpanel/Infohbox/Ironmaindenbutton.position.y = -6
		"weaken":
			$Spellpanel/Infohbox/Weakenbutton.position.y = -6


func _on_repair_button_pressed():
	Currency.repair_wall(wall_hp.max_value)


func _on_upgradewall_button_pressed():
	wall_hp.max_value += Currency.upgrade_wall() 


func _on_ultimate_dragon_button_2_pressed():
	pass # Replace with function body.


func _on_raise_cooldown_timeout():
	Spellhandler.raise_cooldown = false


func _on_bonespearbutton_pressed():
	Spellhandler.current_spell = "bone_spear"


func _on_ironmaindenbutton_pressed():
	show_spell_aoe("iron_maiden")


func _on_golembutton_pressed():
	Spellhandler.current_spell = "golem"


func _on_bonespearcooldown_timeout():
	Spellhandler.bone_spear_cooldown = false

func _on_ironmaidencooldown_timeout():
	Spellhandler.iron_maiden_cooldown = false



func _on_weakenbutton_pressed():
	show_spell_aoe("weaken")

func show_spell_aoe(spell):
	if spell_aoe_node != null:
		spell_aoe_node.queue_free()
	Spellhandler.current_spell = spell
	var sp = spell_aoe.instantiate()
	sp.position = Spellhandler.mouse_pos
	$Spellpanel/Infohbox.add_child(sp)
	spell_aoe_node = get_node("Spellpanel/Infohbox/Spell aoe")

func _on_weakencooldown_timeout():
	Spellhandler.weaken_cooldown = false
