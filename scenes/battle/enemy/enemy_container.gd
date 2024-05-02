extends VBoxContainer

signal attack_finished

@onready var health_component : HealthComponent = $HealthComponent
@onready var enemy_texture    : TextureRect     = $Enemy
@onready var enemy_health_bar : ProgressBar     = $HealthBar

@export  var enemy            : Resource = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy == null: return
	if enemy_texture == null: return
	health_component.max_health = enemy.health_points
	enemy_texture.texture = enemy.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _attack():
	# var player = get_tree().get_first_node_in_group("ally")

	pass