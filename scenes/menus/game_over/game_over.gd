extends CanvasLayer


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")


func _on_quit_pressed():
	get_tree().quit()
