extends CharacterBody2D

# Speed and input variables
@export var moveSpeed : float = 600.0
var inputDirection : Vector2 = Vector2(0,0)
var faceDirection : float = 1.0

# Jump variables
@export var jumpVelocity : float = -800.0
var canJump : bool = true
var canDoubleJump : bool = true
@export var doubleJumpUnlocked = true
var hasLanded = false

# Dash variables
@export var dashSpeed : float = 1500.0
var canDash : bool = true
var isDashing : bool = false
@export var dashUnlocked = true

# Grapple variables
@export var grappleVelocity : float = 1600.0
var grappleMomentum : float
@export var grappleMomentumDecay : float = 1600.0 # This uses delta, is per second
var grappleMomentumDirection : Vector2 = Vector2(0,0)
var isGrappling : bool = false
@export var whipUnlocked = true

# Attack variables
@export var attackPointOffest : float = 1.0
var attackDirection : Vector2 = Vector2(0,0)
var isAttacking : bool = false

# Variable that will stop user from controlling the player, can be used for death and cutscenes
@export var playerHasControl = true

# Whip packed scene
@export var playerWhip : PackedScene = preload("res://Player/player_whip.tscn")

# Particle packed scenes
@export var leafParticles : PackedScene = preload("res://Particles/leaf_effect.tscn")
@export var dashParticles : PackedScene = preload("res://Particles/dash_particles.tscn")
@export var groundLandParticles : PackedScene = preload("res://Particles/ground_landing_particles.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Child nodes
@onready var dashTimer = $DashTimer
@onready var coyoteTimer = $CoyoteTimer
@onready var deathTimer = $DeathTimer
@onready var attackDelay = $AttackDelayTimer
@onready var attackPoint = $AttackPoint
@onready var sprite = $Sprite2D
@onready var groundWalkParticles = $"Ground Walk Particles"

func _physics_process(delta):
	
	# Starts coyote time
	if not is_on_floor():
		if(hasLanded and canJump): # Hopefully the last hack in this project
			sprite.stop()
		if(!sprite.is_playing() and playerHasControl):
			sprite.play("Falling")
		groundWalkParticles.emitting = false
		hasLanded = false
		if(canJump and coyoteTimer.is_stopped()):
			coyoteTimer.start()
	
	# Applies gravity outside of a dash
	if not is_on_floor() and !isDashing:
		velocity.y += gravity * delta
	
	# Resets variables when you touch the ground
	elif is_on_floor():
		if(velocity.x > 0):
			groundWalkParticles.emitting = true
			groundWalkParticles.process_material.direction.x = -1
		elif(velocity.x < 0):
			groundWalkParticles.emitting = true
			groundWalkParticles.process_material.direction.x = 1
		else :
			groundWalkParticles.emitting = false
			if(!isAttacking and playerHasControl):
				sprite.stop()
				sprite.play("Idle")
		if(!hasLanded):
			sprite.stop()
			if(playerHasControl):
				sprite.play("Landing")
			var landParticles = groundLandParticles.instantiate()
			get_parent().add_child(landParticles)
			landParticles.position = position
			landParticles.position.y += 100
			hasLanded = true
		canJump = true
		canDoubleJump = true
		if(!isDashing):
			canDash = true
		grappleMomentum -= grappleMomentumDecay * 2 * delta # Increases grapple momentum decay when on the ground, friction :D
		if(grappleMomentum <= 0):
			grappleMomentum = 0
			isGrappling = false
		coyoteTimer.stop()
	
	# Cancels dash on ceiling collision
	elif is_on_ceiling():
		isDashing = false
		velocity.y = 0
		dashTimer.stop()
	
	# Cancels dash on wall collision
	elif is_on_wall():
		isDashing = false
		velocity.x = 0
		dashTimer.stop()
	
	# Gets input direction
	inputDirection = Input.get_vector("left","right","up","down").normalized()
	
	# Changes facing direction
	if(velocity.x > 0):
		faceDirection = 1.0
		sprite.flip_h = false
	elif (velocity.x < 0):
		faceDirection = -1.0
		sprite.flip_h = true
	
	# Allows jumping when not in a dash
	if(!isDashing and playerHasControl):

		# Used for controller deadzone, horizontal input was going through when left stick was pushed up?
		if abs(inputDirection.x) > 0.35:
			# Moves character
			velocity.x = ((inputDirection.x/abs(inputDirection.x)) * moveSpeed) + (grappleMomentumDirection.x * grappleMomentum)
			if(is_on_floor() and !isAttacking):
				sprite.play("Run")
		else:
			# Prevents momentum, still feels a little weird when grappling
			#sprite.stop()
			velocity.x = 0 + (grappleMomentumDirection.x * grappleMomentum)
		
		# Jump
		if Input.is_action_just_pressed("jump") and canJump:
			sprite.stop()
			sprite.play("Jump")
			velocity.y = jumpVelocity
			canJump = false
		# Double Jump
		elif Input.is_action_just_pressed("jump") and canDoubleJump and doubleJumpUnlocked:
			sprite.stop()
			sprite.play("Jump")
			velocity.y = jumpVelocity
			canDoubleJump = false
			var particle = leafParticles.instantiate()
			add_child(particle)
			particle.position.y += 60
	
	# Reduces grappling momentum
	grappleMomentum -= grappleMomentumDecay * delta
	if(grappleMomentum <= 0):
		grappleMomentum = 0
	
	# Dash mechanic, takes precedence over all other movement
	if Input.is_action_just_pressed("dash") and canDash and dashUnlocked and playerHasControl:
		canDash = false
		isDashing = true
		grappleMomentum = 0
		if(inputDirection != Vector2.ZERO):
			velocity = dashSpeed * inputDirection
		else:
			velocity = dashSpeed * Vector2(faceDirection,0.0)
		var particle = dashParticles.instantiate()
		add_child(particle)
		if(faceDirection > 0):
			particle.trailParticles.emitting = true
		else:
			particle.flippedTrailParticles.emitting = true
		particle = leafParticles.instantiate()
		add_child(particle)
		if(inputDirection != Vector2.ZERO):
			particle.rotation_degrees = 90 + (180/PI) * atan2(inputDirection.y,inputDirection.x)
		else:
			particle.rotation_degrees = 90 * faceDirection
		particle.position += 80 * Vector2(inputDirection.x,inputDirection.y).normalized()
		dashTimer.start()	

		# Can only attack once at a time
	if(!isAttacking and whipUnlocked and !isDashing and playerHasControl):
		
		# Controller and mouse attack handled differently
		# Controller using directional input
		if(Input.is_action_just_pressed("attack_controller")):
			isAttacking = true
			if(inputDirection != Vector2.ZERO):
				attackDirection = inputDirection
				if(attackDirection.x >= 0):
					attackPoint.position.x = -20
					sprite.flip_h = false
				elif(attackDirection.x < 0):
					attackPoint.position.x = 20
					sprite.flip_h = true
			else:
				attackDirection = Vector2(faceDirection,0.0)
				if(attackDirection.x >= 0):
					attackPoint.position.x = -20
					sprite.flip_h = false
				elif(attackDirection.x < 0):
					attackPoint.position.x = 20
					sprite.flip_h = true
			sprite.stop()
			sprite.play("Attack")
			attackDelay.start()
		
		# Mouse using mouse cursor position
		elif(Input.is_action_just_pressed("attack_mouse")):
			isAttacking = true
			attackDirection = (get_global_mouse_position()-position).normalized()
			# Switches attack direction based on where you click
			if(attackDirection.x >= 0):
				faceDirection = 1
				sprite.flip_h = false
				attackPoint.position.x = -20
			elif(attackDirection.x < 0):
				faceDirection = -1
				sprite.flip_h = true
				attackPoint.position.x = 20
			sprite.stop()
			sprite.play("Attack")
			attackDelay.start()
			
	move_and_slide()
	
# Die
func death():
	isAttacking = false
	velocity.x = 0
	sprite.stop()
	sprite.play("Death")
	sprite.position.y += 70
	sprite.rotation_degrees = 90
	playerHasControl = false
	deathTimer.start()

# Timer to stay dashing only for the dedicated amount of time
func _on_dash_timer_timeout():
	isDashing = false
	velocity = Vector2.ZERO

# Coyote time timer
func _on_coyote_timer_timeout():
	canJump = false


func _on_death_timer_timeout():
	Transition.changeScene(get_parent().scene_file_path)


func _on_attack_delay_timer_timeout():
	var whip = playerWhip.instantiate()
	add_child(whip)
	whip.transform = attackPoint.transform
	whip.rotation_degrees = 90 + (180/PI) * atan2(attackDirection.y,attackDirection.x)
