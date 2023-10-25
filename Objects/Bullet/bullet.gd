extends Area2D

@export var speed : float = 200.0
@export var jumpVelocity : float = -400.0
@export var killTime : float = 5

@onready var sprite = $Bullet
@onready var killTimer = $KillTimer

var direction : int = 1

func _ready():
	killTimer.start(killTime)

func _physics_process(delta):
	position += transform.x * speed * delta * direction

func _on_body_entered(body):
	if body.has_method("death"):
		body.death() # kills the thing the bullet hits
	queue_free() # kills the bullet (rip)

func _on_kill_timer_timeout():
	queue_free()
