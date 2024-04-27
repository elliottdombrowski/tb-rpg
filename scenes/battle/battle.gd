extends Control

signal textbox_closed

@onready var actions_panel     : Panel           = $ActionsPanel
@onready var textbox           : Panel           = $Textbox
@onready var textbox_label     : Label           = $Textbox/Label
@onready var textbox_ticker    : Label           = $Textbox/Ticker
@onready var player_health_bar : ProgressBar     = $PlayerPanel/PlayerData/ProgressBar
@onready var enemy_texture     : TextureRect     = $EnemyContainer/Enemy
@onready var enemy_health_bar  : ProgressBar     = $EnemyContainer/ProgressBar
@onready var animation         : AnimationPlayer = $AnimationPlayer

@export_range(0,1) var run_chance : float = 0.5
@export            var enemy      : Resource = null

var current_player_health : int  = 0
var current_enemy_health  : int  = 0
var is_defending          : bool = false


func _ready():
	set_health(player_health_bar, PlayerStats.current_health_points, PlayerStats.max_health_points)
	set_health(enemy_health_bar, enemy.health_points, enemy.health_points)
	enemy_texture.texture = enemy.texture
	
	# Initialize health values
	current_player_health = PlayerStats.current_health_points
	current_enemy_health  = enemy.health_points
	
	textbox.hide()
	actions_panel.hide()
	
	display_text("A wild %s appears!" % enemy.name.to_upper())
	
	await textbox_closed
	actions_panel.show()


func set_health(progress_bar: ProgressBar, health, max_health):
	progress_bar.value     = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]


func enemy_turn():
	display_text("%s launches at you!" % enemy.name)
	await textbox_closed
	
	if is_defending:
		is_defending = false
		animation.play("player_damaged_defending")
		await animation.animation_finished
		
		display_text("You defended successfully!")
		await textbox_closed
	else:
		display_text("%s did %d damage!" % [enemy.name, enemy.attack_damage])
		await textbox_closed
		
		# Make sure to never let health drop below 0
		current_player_health = max(0, current_player_health - enemy.attack_damage)
		set_health(player_health_bar, current_player_health, PlayerStats.max_health_points)
		
		animation.play("player_damaged")
		await animation.animation_finished
	
	actions_panel.show()


func display_text(text):
	actions_panel.hide()
	textbox.show()
	textbox_label.text = text


func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and textbox.visible:
		textbox.hide()
		textbox_closed.emit()


func _on_attack_pressed():
	display_text("You swing your sword!")
	await textbox_closed
	display_text("You dealt %d damage!" % PlayerStats.attack_damage)
	await textbox_closed
	
	# Make sure to never let health drop below 0
	current_enemy_health = max(0, current_enemy_health - PlayerStats.attack_damage)
	set_health(enemy_health_bar, current_enemy_health, enemy.health_points)
	
	animation.play("enemy_damaged")
	await animation.animation_finished
	
	# Check if enemy is dead
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name)
		await textbox_closed
		animation.play("enemy_defeated")
		await animation.animation_finished
		await get_tree().create_timer(.25).timeout
		return
	
	enemy_turn()


func _on_defend_pressed():
	is_defending = true
	display_text("You prepare defensively!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	enemy_turn()


func _on_run_pressed():
	if randf() > run_chance:
		display_text("Failed to run away!")
		return

	display_text("Got away safely!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	get_tree().quit()
