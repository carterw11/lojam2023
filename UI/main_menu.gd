extends Control



func _on_settings_pressed():
	get_tree().change_scene_to_file("res://UI/settings.tscn")


func _on_quit_pressed():
	get_tree().quit()

func _on_play_mouse_entered():
	MusicController.play_hoverFX()


func _on_settings_mouse_entered():
	MusicController.play_hoverFX()


func _on_quit_mouse_entered():
	MusicController.play_hoverFX()
