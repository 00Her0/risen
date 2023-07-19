extends Node

var sound = true
var music = true
var souls := 7 # CHANGED FOR TESTING
var soul_list = []
var wall_hp = 200
var wall_max_hp = 200
var wall_repair_bool = false
var wall_upgrade_bool = false
var current_wave
var time_to_next_wave

func add_soul(amount):
	souls += amount
	
func use_soul(amount):
	if amount <= souls:
		souls -= amount
		return true
	else: return false

func add_dead(dead_soul):
	soul_list.append(dead_soul)
	
func remove_dead(dead_soul):
	for soul in soul_list:
		if soul == dead_soul:
			soul_list.remove_at(soul_list.find(soul))

func repair_wall(max):
	if !wall_repair_bool:
		var amount_to_repair = max - wall_hp
		var soul_cost = round(amount_to_repair/10)
		var used_souls = min(soul_cost, souls)
		use_soul(used_souls)
		wall_hp += used_souls * 10
		wall_repair_bool = true
	
func upgrade_wall():
	if !wall_upgrade_bool:
		var upgrade_amount = souls * 20
		use_soul(souls)
		wall_upgrade_bool = true
		wall_hp += upgrade_amount
		return upgrade_amount
	else: return 0

func reset():
	souls = 0
	soul_list = []
	wall_hp = 200
	wall_max_hp = 200
	wall_repair_bool = false
	wall_upgrade_bool = false
	current_wave = 0
