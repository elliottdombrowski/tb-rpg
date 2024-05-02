extends CharacterBody2D

const MAX_SPEED_ROAMING = 40
const MAX_SPEED_HUNTING = 100

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var sprite           : Sprite2D          = $Sprite2D

@export  var enemy  : Resource = null


func _ready():
	if enemy == null: return
	sprite.texture = enemy.texture
	pass


func _process(_delta):
	var direction = _get_direction_to_player()
	direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = direction * MAX_SPEED_ROAMING
	move_and_slide()


func _get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return Vector2.ZERO
	navigation_agent.target_position = player.global_position
	return (player.global_position - global_position).normalized()