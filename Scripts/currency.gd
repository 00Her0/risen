extends Node

var sound = true
var souls := 7 # CHANGED FOR TESTING
var soul_list = []
var wall_hp = 0 #used to track wall hp for UI
var wall_repair_bool = false
var wall_upgrade_bool = false

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
	pass
	
func upgrade_wall():
	if !wall_upgrade_bool:
		var upgrade_amount = souls * 20
		use_soul(souls)
		wall_upgrade_bool = true
		wall_hp += upgrade_amount
		return upgrade_amount
	else: return 0
