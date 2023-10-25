extends CharacterBody2D

@export var speed : float = 100.0
@export var jumpVelocity : float = -400.0
@export var cycleTime : float = 9
@export var shootingTime : float = 2
@export var canMove : bool = true
@export var isFlying : bool = false
@export var canShoot : bool = false
@export var Bullet : PackedScene = preload("res://Objects/Bullet/bullet.tscn")

@onready var cycleTimer = $CycleTimer
@onready var shootingTimer = $ShootingTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : int = 1

func _ready():
	cycleTimer.start(cycleTime)
	
	if canShoot:
		shootingTimer.start(shootingTime)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and !isFlying:
		velocity.y += gravity * delta
	
	if is_on_wall():
		ChangeDirection()
		
	if canMove:
		velocity.x = direction * speed

	move_and_slide()
	
func ChangeDirection():
	direction *= -1
	cycleTimer.start(cycleTime)

func _on_cycle_timer_timeout():
	ChangeDirection()

func _on_shooting_timer_timeout():
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	if direction == 1:
		bullet.transform = $MarkerRight.global_transform
	else:
		bullet.transform = $MarkerLeft.global_transform
	bullet.direction = direction
	shootingTimer.start(shootingTime)
	
func death():
	queue_free()
