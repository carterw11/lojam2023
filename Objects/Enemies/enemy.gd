extends CharacterBody2D

@export var speed : float = 50.0
@export var jumpVelocity : float = -400.0
@export var cycleTime : float = 9
@export var shootingTime : float = 2
@export var canMove : bool = true
@export var isFlying : bool = false
@export var canShoot : bool = false
@export var Bullet : PackedScene = preload("res://Objects/Bullet/bullet.tscn")
@export var deathParticles : PackedScene = preload("res://Particles/enemy_death_particle.tscn")
@export var direction : Vector2 = Vector2(1, 0)

@onready var cycleTimer = $CycleTimer
@onready var shootingTimer = $ShootingTimer
@onready var sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	if direction.x == 1:
		sprite.set_flip_h(true)
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

	
func ChangeDirection():
	direction *= -1
	sprite.set_flip_h(!sprite.flip_h)
	cycleTimer.start(cycleTime)

func _on_cycle_timer_timeout():
	ChangeDirection()

func _on_shooting_timer_timeout():
	
	sprite.play("shooting")
	await get_tree().create_timer(0.2).timeout
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	if direction.x == 1:
		bullet.transform = $MarkerRight.global_transform
	else:
		bullet.transform = $MarkerLeft.global_transform
	bullet.direction = direction
	shootingTimer.start(shootingTime)
	await get_tree().create_timer(0.3).timeout
	sprite.stop()
	
	
	
func death():
	var particle = deathParticles.instantiate()
	get_parent().add_child(particle)
	particle.position = position
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.death()
