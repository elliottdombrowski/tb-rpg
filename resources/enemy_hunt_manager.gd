extends Resource
class_name EnemyHuntManager

enum {ROAMING, HUNTING, SEARCHING}

var state: int:
	get: return state
	set(value):
		state = value
		match state:
			HUNTING: hunting.emit()
			ROAMING: roaming.emit()
			SEARCHING: searching.emit()

signal roaming
signal hunting
signal searching