extends Area2D

@export var whipTime : float = 0.2

@onready var whipLifespanTimer = $WhipLifespan
@onready var whipSprite = $Sprite2D
@onready var collisionShape = $WhipSnap

func _physics_process(_delta):
	if(whipLifespanTimer.is_stopped()):
		whipLifespanTimer.start(whipTime)

func _on_whip_lifespan_timeout():
	get_parent().isAttacking = false
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.death()
	elif body.has_method("breakWall"):
		body.breakWall()
