extends CharacterBody2D

const MAX_SPEED              = 145
const MAX_SPEED_CLIMBING     = 100
const ACCELERATION_SMOOTHING = 25

var is_on_stairs = false

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@export var terrain_manager : Node


func _ready():
	if terrain_manager == null: return
	terrain_manager.on_ground.connect(_on_ground_entered)
	terrain_manager.on_stairs.connect(_on_stairs_entered)


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction       = movement_vector.normalized()
	
	# Take out acceleration smoothing for now. Feels strange in this format.
	#var target_velocity = direction * MAX_SPEED
	#velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	velocity = direction * (MAX_SPEED_CLIMBING if is_on_stairs else MAX_SPEED)
	handle_animation(direction)
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var y_movement = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	return Vector2(x_movement, y_movement)


func handle_animation(direction: Vector2):
	if direction:
		if direction == Vector2(1, 0):  # Right
			animation.flip_h = true
			animation.play("walk_horizontal")
		if direction == Vector2(-1, 0): # Left
			animation.flip_h = false
			animation.play("walk_horizontal")
		if direction == Vector2(0, 1):  # Down
			animation.play("walk_down")
		if direction == Vector2(0, -1): # Up
			animation.play("walk_up")
		return
	else:
		animation.play("idle")
		return


func _on_ground_entered():
	is_on_stairs = false


func _on_stairs_entered():
	is_on_stairs = true
