extends Control

@onready var masterSlider = $AudioContainer/Slider/Master
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	masterSlider.value = AudioServer.get_bus_volume_db(master_bus)

#BACK TO MAIN MENU
func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

#VIDEO FUNCTIONS
func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_borderless_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_windowed_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#SOUND FUNCTION
func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)


func _on_return_button_mouse_entered():
	MusicController.play_hoverFX()
