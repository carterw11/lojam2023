extends CharacterBody2D

@export var speed : float = 50.0
@export var jumpVelocity : float = -400.0
@export var cycleTime : float = 9
@export var shootingTime : float = 2
@export var canMove : bool = true
@export var isFlying : bool = false
@export var canShoot : bool = false
@export var Bullet : PackedScene = preload("res://Objects/Bullet/bullet.tscn")
@export var direction : Vector2 = Vector2(1, 0)

@onready var cycleTimer = $CycleTimer
@onready var shootingTimer = $ShootingTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	cycleTimer.start(cycleTime)
	
	if canShoot:
		shootingTimer.start(shootingTime)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and !isFlying:
		velocity.y += gravity * delta
	
	if is_on_wall() or ((is_on_floor() or is_on_ceiling()) && isFlying):
		ChangeDirection()
		
	if canMove:
		if isFlying:
			velocity.y = direction.y * speed
		velocity.x = direction.x * speed

	move_and_slide()
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var body = collision.get_collider()
		if body.is_in_group("Player"):
			body.death()
	
func ChangeDirection():
	direction *= -1
	cycleTimer.start(cycleTime)

func _on_cycle_timer_timeout():
	ChangeDirection()

func _on_shooting_timer_timeout():
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	if direction.x == 1:
		bullet.transform = $MarkerRight.global_transform
	else:
		bullet.transform = $MarkerLeft.global_transform
	bullet.direction = direction
	shootingTimer.start(shootingTime)
	
func death():
	queue_free()
