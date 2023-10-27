extends Control

@onready var masterSlider = $AudioContainer/Sliders/Master
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	masterSlider.value = AudioServer.get_bus_volume_db(master_bus)
	

#VIDEO SETTINGS
#FULLSCREEN CHECKBOX
func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#BORDERLESS CHECKBOX
func _on_borderless_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#WINDOWED CHECKBOX
func _on_windowed_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#RETURN TO MENU
func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

#SOUND SETTINGS
func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)

#MOUSE HOVER FX
func _on_return_button_mouse_entered():
	MusicController.play_hoverFX()
