extends Node2D

@onready var player = $Player
@onready var bean = $bean
@onready var playerWalkInTimer = $PlayerWalkIn
@onready var beanThrowTimer = $BeanThrowTime
@onready var wizardTalkTime = $WizardTalkTime
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
	$PlayerText.visible = !$PlayerText.visible
	$WizardText.visible = !$WizardText.visible
	bean.visible = !bean.visible
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
	$PlayerText.show()
	beanThrowTimer.start()

func _on_wizard_talk_time_timeout():
	$WizardText.hide()
	wizardIsFlying = true
	wizardFlyOffTimer.start()

func _on_bean_throw_time_timeout():
	$PlayerText.hide()
	$WizardText.show()
	bean.visible = !bean.visible
	wizardTalkTime.start()
	
	


func _on_wizard_fly_offscreen_timeout():
	wizardIsFlying = false
	player.velocity.x = 600
	bean.visible = !bean.visible
	MusicController.play_powerUp()
	player.sprite.stop()
	player.sprite.play("Run")
	playerWalkOutTimer.start()
#test

func _on_player_walk_out_timeout():
	Transition.changeScene("res://Levels/Level1.tscn")
