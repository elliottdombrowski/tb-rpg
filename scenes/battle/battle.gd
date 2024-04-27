extends Control

signal textbox_closed

@onready var actions_panel     : Panel = $ActionsPanel
@onready var textbox           : Panel = $Textbox
@onready var textbox_label     : Label = $Textbox/Label
@onready var textbox_ticker    : Label = $Textbox/Ticker
@onready var player_health_bar : ProgressBar = $PlayerPanel/PlayerData/ProgressBar
@onready var enemy_texture     : TextureRect = $EnemyContainer/Enemy
@onready var enemy_health_bar  : ProgressBar = $EnemyContainer/ProgressBar

@export_range(0,1) var run_chance : float = 0.5
@export var enemy : Resource = null

func _ready():
	set_health(player_health_bar, PlayerStats.current_health, PlayerStats.max_health)
	set_health(enemy_health_bar, enemy.health, enemy.health)
	enemy_texture.texture = enemy.texture
	
	textbox.hide()
	actions_panel.hide()
	
	display_text("A wild %s appears!" % enemy.name.to_upper())
	
	await textbox_closed
	actions_panel.show()


func set_health(progress_bar: ProgressBar, health, max_health):
	progress_bar.value     = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]



func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and textbox.visible:
		textbox.hide()
		textbox_closed.emit()


func display_text(text):
	textbox.show()
	textbox_label.text = text


func _on_run_pressed():
	if randf() > run_chance:
		display_text("Failed to run away!")
		return

	display_text("Got away safely!")
	await textbox_closed
	await get_tree().create_timer(.25).timeout
	get_tree().quit()
