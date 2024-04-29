extends Control

signal textbox_closed

# @onready var actions_panel        : Panel           = $ActionsPanel
@onready var actions_panel        : HBoxContainer   = $PlayerPanel/ActionsPanel
@onready var textbox              : Panel           = $Textbox
@onready var textbox_label        : Label           = $Textbox/Label
@onready var textbox_ticker       : Label           = $Textbox/Ticker
@onready var player_health_bar    : ProgressBar     = $PlayerPanel/PlayerData/ProgressBar
@onready var enemy_texture        : TextureRect     = $EnemyContainer/Enemy
@onready var enemy_health_bar     : ProgressBar     = $EnemyContainer/ProgressBar
@onready var animation            : AnimationPlayer = $AnimationPlayer

@export_range(0,1) var run_chance : float           = 0.5
@export            var enemy      : Resource        = null

var current_player_health         : int             = 0
var current_enemy_health          : int             = 0
var is_defending                  : bool            = false

const CRITICAL_HIT_MODIFIER       : float           = 1.5


func _ready():
	set_health(player_health_bar, PlayerStats.current_health_points, PlayerStats.max_health_points)
	set_health(enemy_health_bar, enemy.health_points, enemy.health_points)
	
	# Make sure enemy has texture - this is the only value with a null default
	if enemy_texture == null: return
	enemy_texture.texture = enemy.texture
	
	# Initialize health values
	current_player_health = PlayerStats.current_health_points
	current_enemy_health  = enemy.health_points
	
	textbox.hide()
	toggle_player_ui(true)
	
	display_text("A wild %s appears!" % enemy.entity_name.to_upper())
	
	await textbox_closed
	toggle_player_ui(false)


func set_health(progress_bar: ProgressBar, health, max_health):
	progress_bar.value     = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "%d/%d" % [health, max_health]


func enemy_turn():
	display_text("%s launches at you!" % enemy.entity_name)
	await textbox_closed
	
	var damage_dealt = await handle_attack(
		enemy.entity_name,
		PlayerStats.entity_name,
		enemy.attack_damage,
		enemy.crit_chance,
		PlayerStats.defense,
		PlayerStats.dodge_chance
	)
	
	if damage_dealt == 0: 
		toggle_player_ui(false)
		return # If player dodged
	
	if is_defending:
		is_defending = false
		animation.play("player_damaged")
		await animation.animation_finished
	else:
		animation.play("player_damaged_defending")
		await animation.animation_finished
	
	# Make sure to never let health drop below 0
	current_player_health = max(0, current_player_health - damage_dealt)
	set_health(player_health_bar, current_player_health, PlayerStats.max_health_points)
	
	if current_player_health == 0:
		display_text("%s were defeated in battle..." % PlayerStats.entity_name)
		await textbox_closed
		get_tree().change_scene_to_file("res://scenes/menus/game_over/game_over.tscn")
	else:
		toggle_player_ui(false)

func display_text(text):
	toggle_player_ui(true)
	textbox.show()
	textbox_label.text = text


func handle_attack(
	attacking_entity_name,
	defending_entity_name,
	attacking_entity_attack_damage, 
	attacking_entity_crit_chance,
	defending_entity_defense,
	defending_entity_dodge_chance
):
	var is_critical_hit  : bool = Utils.dice_roll(attacking_entity_crit_chance)
	var is_attack_dodged : bool = Utils.dice_roll(defending_entity_dodge_chance)
	var damage_dealt     : float  = 0.0
	
	# Just break early if the attack is misses.
	if is_attack_dodged:
		display_text("but %s rolled out of the way..." % defending_entity_name)
		await textbox_closed
		return round(damage_dealt)
	
	damage_dealt = attacking_entity_attack_damage
	if is_critical_hit:
		damage_dealt = damage_dealt * CRITICAL_HIT_MODIFIER
		display_text("%s dealt a critical hit!" % attacking_entity_name)
		await textbox_closed
	if is_defending:
		damage_dealt = max(0, damage_dealt / defending_entity_defense)
		display_text("%s prepares defensively..." % defending_entity_name)
		await textbox_closed
	
	display_text("%s did %d damage!" % [attacking_entity_name, round(damage_dealt)])
	await textbox_closed
	
	return round(damage_dealt)


func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and textbox.visible:
		textbox.hide()
		textbox_closed.emit()


func _on_attack_pressed():
	display_text("You swing your sword!")
	await textbox_closed
	
	var damage_dealt = await handle_attack(
		PlayerStats.entity_name,
		enemy.entity_name,
		PlayerStats.attack_damage,
		PlayerStats.crit_chance,
		enemy.defense,
		enemy.dodge_chance
	)

	if damage_dealt == 0:
		enemy_turn()
		return # If enemy dodged
	
	# Make sure to never let health drop below 0
	current_enemy_health = max(0, current_enemy_health - damage_dealt)
	set_health(enemy_health_bar, current_enemy_health, enemy.health_points)
	
	animation.play("enemy_damaged")
	await animation.animation_finished
	
	# Check if enemy is dead
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.entity_name)
		await textbox_closed
		animation.play("enemy_defeated")
		await animation.animation_finished
		display_text("You gained %d experience points." % enemy.experience_dropped)
		await textbox_closed
		get_tree().change_scene_to_file("res://scenes/menus/title/title.tscn")
		return
	
	enemy_turn()


func _on_defend_pressed():
	is_defending = true
	display_text("You prepare defensively!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	enemy_turn()


func _on_run_pressed():
	if Utils.dice_roll(run_chance):
		display_text("Failed to run away!")
		return

	display_text("Got away safely!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	get_tree().change_scene_to_file("res://scenes/menus/title/title.tscn")


func _on_running_pressed():
	pass # Replace with function body.


func toggle_player_ui(val: bool):
		var buttons = get_tree().get_nodes_in_group("player_battle_action_buttons")
		for button in buttons:
			button.disabled = val