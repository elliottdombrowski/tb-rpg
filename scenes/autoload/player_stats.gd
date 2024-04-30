extends Node

# Player personality
var entity_name              : String = "You"
# TODO - make this its own enum
var type                     : Array[String] = ["FIRE"]
var type_resistances         : Array[String] = ["FIRE"]
var type_weaknesses          : Array[String] = ["ICE"]

# Leveling related stuff
var current_level            : int           = 1
var experience_total         : int           = 0
var experience_to_next_level : int           = 0

# Battle stuff
var max_health_points        : int           = 200 
var current_health_points    : int           = 200
var max_magic_points         : int           = 20
var current_magic_points     : int           = 20
var attack_damage            : int           = 1
# var attack_damage            : int           = 100
var attack_speed             : float         = 10
var crit_chance              : float         = 0.5
var dodge_chance             : float         = 0.5
# var crit_chance              : float         = 0.1
# var dodge_chance             : float         = 0.1
var defense                  : int           = 30

# Magic stuff
var spells : Array[Dictionary] = [
	{
		"spell_name"      : "FireI",
		"spell_type"      : "FIRE",
		"spell_level"     : 1,
		"spell_max_level" : 3,
		"spell_damage"    : 40,
		"spell_mp_cost"   : 5,
	}
]
