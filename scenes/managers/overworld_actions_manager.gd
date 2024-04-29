extends Node

@export var flash_ability : PackedScene

var can_use_ability : bool = true


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if can_use_ability and Input.is_action_just_pressed("flash"):
		can_use_ability = false
		# TODO - can this be done more efficiently?
		var player = get_tree().get_first_node_in_group("player")  as CharacterBody2D
		var flash_instance = flash_ability.instantiate() as Node2D
		player.add_child(flash_instance)
		flash_instance.global_position = Vector2(player.position.x, (player.position.y - 15))
		
		# Once animation is working, replace this to wait for anim finish
		await get_tree().create_timer(.3).timeout
		flash_instance.queue_free()
		can_use_ability = true
