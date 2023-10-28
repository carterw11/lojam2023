extends Control

func _ready():
	MusicController.play_menu()
	

func _on_play_pressed():
	MusicController.play_startFX()
	await get_tree().create_timer(0.85).timeout
	MusicController.stop_menu()
	Transition.changeScene("res://Levels/cutscene_test.tscn")


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
