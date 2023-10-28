extends Node2D

@onready var player = $Player
@onready var playerWalkInTimer = $PlayerWalkIn
@onready var beanThrowTimer = $BeanThrowTime
@onready var wizardFlyOffTimer = $WizardFlyOffscreen
@onready var initialTimer = $ReadyTimer
@onready var wizard = $Wizard
@onready var beanStalk = $Beanstalk
var wizardIsFlying : bool  = false
@onready var playerWalkOutTimer = $PlayerWalkOut

func _physics_process(_delta):
	if(wizardIsFlying):
		wizard.position.y -= 15
		beanStalk.position.y -= 15

func _ready():
	initialTimer.start()

func _on_ready_timer_timeout():
	player.velocity.x = 600
	player.sprite.stop()
	player.sprite.play("Run")
	playerWalkInTimer.start()


func _on_player_walk_in_timeout():
	player.velocity.x = 0
	player.sprite.stop()
	player.sprite.play("Idle")
	beanThrowTimer.start()


func _on_bean_throw_time_timeout():
	wizardIsFlying = true
	wizardFlyOffTimer.start()


func _on_wizard_fly_offscreen_timeout():
	wizardIsFlying = false
	player.velocity.x = 600
	player.sprite.stop()
	player.sprite.play("Run")
	playerWalkOutTimer.start()


func _on_player_walk_out_timeout():
	Transition.changeScene("res://Levels/Level2.tscn")
