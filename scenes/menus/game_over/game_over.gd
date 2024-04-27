extends CanvasLayer


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")


func _on_quit_to_title_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/title/title.tscn")


func _on_quit_game_pressed():
	get_tree().quit()
