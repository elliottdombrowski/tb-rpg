extends CharacterBody2D

const MAX_SPEED_ROAMING   : int = 0
const MAX_SPEED_HUNTING   : int = 55
const MAX_SPEED_SEARCHING : int = 50
const HUNTING_TIME        : int = 5

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var hunt_radius      : Area2D            = $HuntRadius
@onready var sprite           : Sprite2D          = $Sprite2D

@export  var enemy              : Resource = null
@export  var enemy_hunt_manager : Resource = null


func _ready():
	if enemy == null: return
	sprite.texture = enemy.texture
	enemy_hunt_manager.roaming.connect(_on_roaming)
	enemy_hunt_manager.hunting.connect(_on_hunting)
	enemy_hunt_manager.searching.connect(_on_searching)


func _process(_delta):
	print_debug(enemy_hunt_manager.state)
	var direction = _get_direction_to_player()
	direction = (navigation_agent.get_next_path_position() - global_position).normalized()

	match enemy_hunt_manager.state:
		EnemyHuntManager.ROAMING  : velocity = Vector2(MAX_SPEED_ROAMING, MAX_SPEED_ROAMING)
		EnemyHuntManager.HUNTING  : velocity = direction * MAX_SPEED_HUNTING
		EnemyHuntManager.SEARCHING: velocity = direction * MAX_SPEED_SEARCHING
	
	# TEMPORARY BANDAID
	if enemy_hunt_manager.state != EnemyHuntManager.ROAMING:
		move_and_slide()


func _get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: 
		return Vector2.ZERO
	navigation_agent.target_position = player.global_position
	return (player.global_position - global_position).normalized()

func _on_hunt_radius_area_entered(_area: Area2D):
	enemy_hunt_manager.state = EnemyHuntManager.HUNTING


func _on_hunt_radius_area_exited(_area:Area2D):
	enemy_hunt_manager.state = EnemyHuntManager.SEARCHING


func _on_roaming(): pass


func _on_hunting(): pass


func _on_searching():
	await get_tree().create_timer(HUNTING_TIME).timeout
	enemy_hunt_manager.state = EnemyHuntManager.ROAMING
