extends Node

signal ready_to_attack

@onready var atb_timer : Timer = $%ATBTimer

@export var entity     : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	if entity == null: return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
