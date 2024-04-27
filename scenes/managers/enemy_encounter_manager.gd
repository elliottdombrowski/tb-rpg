extends Node

signal enemy_encounter_started
signal enemy_encounter_ended

@export var enemy_encounter_chance : float = 0.01


func _process(delta):
	var start_enemy_encounter : bool = Utils.dice_roll(enemy_encounter_chance)
	if start_enemy_encounter:
		enemy_encounter_started.emit() 
		#pass
		#return get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")



