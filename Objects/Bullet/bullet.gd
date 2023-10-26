extends Area2D

@export var speed : float = 200.0
@export var rotateSpeed : float = 20.0
@export var killTime : float = 5
@export var graceTime : float = 0.5

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var killTimer = $KillTimer
@onready var grace = $Grace

var direction : Vector2 = Vector2(1, 0)
var active : bool = false

func _ready():
	grace.start(graceTime)
	killTimer.start(killTime)

func _physics_process(delta):
	sprite.rotate(deg_to_rad(0.1 * rotateSpeed))
	position += speed * delta * direction

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.death() # kills the thing the bullet hits
		queue_free()
	elif body.is_in_group("Enemy"):
		if active:
			body.death()
			queue_free() # kills the bullet (rip)
	else:
		queue_free()

func _on_kill_timer_timeout():
	queue_free()

func _on_grace_timeout():
	active = true


func _on_area_entered(area):
	if area.is_in_group("playerAttack"):
		direction = (self.position - area.get_parent().position).normalized()
		speed *= 3
