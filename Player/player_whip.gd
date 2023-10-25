extends Area2D

@export var whipTime : float = 0.2

@onready var whipLifespanTimer = $WhipLifespan
@onready var whipSprite = $Sprite2D
@onready var collisionShape = $WhipSnap

func _physics_process(_delta):
	if(whipLifespanTimer.is_stopped()):
		whipLifespanTimer.start(whipTime)
	else:
		self.collisionShape.position.y -= 13

func _on_whip_lifespan_timeout():
	get_parent().isAttacking = false
	queue_free()
