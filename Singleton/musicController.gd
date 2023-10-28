extends Node

var main_music = load("res://Sounds/Main Theme Master.wav")
var start_sound = load("res://Sounds/Start Sound.wav")
var hover_sound = load("res://Sounds/Hover Over Button.wav")
var menu_theme = load("res://Sounds/Menu_Theme.mp3")
var boost_jump = load("res://Sounds/Boost Jump.wav")
var death = load("res://Sounds/Death Sound.wav")
var parry = load("res://Sounds/Parry.wav")
var whip = load("res://Sounds/Player Whip Attack.wav")
var powerUp = load("res://Sounds/Power Up.wav")
var proj = load("res://Sounds/Enemy Projectile.wav")

func play_theme():
	$"Main-Theme".stream = main_music
	$"Main-Theme".play()
	
func play_startFX():
	$"Start-SFX".stream = start_sound
	$"Start-SFX".play()
	
func play_hoverFX():
	$"Hover-SFX".stream = hover_sound
	$"Hover-SFX".play()
	
func play_menu():
	$"Menu-Theme".stream = menu_theme
	$"Menu-Theme".play()

func play_boost():
	$"Boost-Jump".stream = boost_jump
	$"Boost-Jump".play()

func play_death():
	$"Death".stream = death
	$"Death".play()
	
func play_parry():
	$"Parry".stream = parry
	$"Parry".play()
	
func play_whip():
	$"Whip".stream = whip
	$"Whip".play()
	
func play_powerUp():
	$"PowerUP".stream = powerUp
	$"PowerUP".play()
	
func play_proj():
	$"Projectile".stream = proj
	$"Projectile".play()

func _on_main_theme_finished():
	play_theme()
	

func stop_menu():
	$"Menu-Theme".stop()
