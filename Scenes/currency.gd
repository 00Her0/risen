extends Node

var souls := 0
var soul_list = []

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
