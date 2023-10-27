extends Node

var main_music = load("res://Main_Theme_v1.mp3")
var start_sound = load("res://Start Sound.wav")
var hover_sound = load("res://Hover Over Button.wav")

func _ready():
	pass

func play_theme():
	$"main-theme".stream = main_music
	$"main-theme".play()
	
func play_startFX():
	$"start-sound".stream = start_sound
	$"start-sound".play()
func play_hoverFX():
	$"hover-sound".stream = hover_sound
	$"hover-sound".play()
