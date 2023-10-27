extends Node

#var main_music = load("res://Main_Theme_v1.mp3")
var start_sound = load("res://Sounds/Start Sound.wav")
var hover_sound = load("res://Sounds/Hover Over Button.wav")

#func play_theme():
	#$"main-theme".stream = main_music
	#$"main-theme".play()
	
func play_startFX():
	$"Start-SFX".stream = start_sound
	$"Start-SFX".play()
func play_hoverFX():
	$"Hover-SFX".stream = hover_sound
	$"Hover-SFX".play()
