extends Camera2D

const ZOOM_RATE : float = .7

var target_position = Vector2.ZERO


func _ready():
	make_current() # Make camera -> current_camera
	zoom = Vector2(ZOOM_RATE, ZOOM_RATE)


func _process(delta):
	get_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func get_target():
	var player = get_tree().get_first_node_in_group("player") as Node2D # Get player's current position
	if player == null: return
	target_position = player.global_position
