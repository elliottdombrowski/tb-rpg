extends Node
class_name HealthComponent

signal died

@export var max_health : float = 999
var current_health

func _ready():
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	Callable(check_death).call_deferred() # Call check_death on next idle frame


func check_death():
	if current_health == 0:
		died.emit()