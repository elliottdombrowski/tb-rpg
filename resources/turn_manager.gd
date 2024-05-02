extends Resource
class_name TurnManager

enum {ALLY_TURN, ENEMY_TURN}

var turn: int:
	get: return turn
	set(value):
		turn = value
		match turn:
			ALLY_TURN: ally_turn_started.emit()
			ENEMY_TURN: enemy_turn_started.emit()

signal ally_turn_started
signal enemy_turn_started
