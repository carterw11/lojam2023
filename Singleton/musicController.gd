extends Node

var main_music = load("res://Sounds/Main Theme Master.wav")
var start_sound = load("res://Sounds/Start Sound.wav")
var hover_sound = load("res://Sounds/Hover Over Button.wav")

func play_theme():
	$"Main-Theme".stream = main_music
	$"Main-Theme".play()
	

	
func play_startFX():
	$"Start-SFX".stream = start_sound
	$"Start-SFX".play()
func play_hoverFX():
	$"Hover-SFX".stream = hover_sound
	$"Hover-SFX".play()


func _on_main_theme_finished():
	play_theme()
