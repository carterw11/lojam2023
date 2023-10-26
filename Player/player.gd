extends CharacterBody2D

# Speed and input variables
@export var moveSpeed : float = 300.0
var inputDirection : Vector2 = Vector2(0,0)
var faceDirection : float = 1.0

# Jump variables
@export var jumpVelocity : float = -400.0
var canJump : bool = true
var canDoubleJump : bool = true
@export var doubleJumpUnlocked = true

# Dash variables
@export var dashSpeed : float = 725.0
var canDash : bool = true
var isDashing : bool = false
@export var dashUnlocked = true

# Grapple variables
@export var grappleVelocity : float = 800.0
var grappleMomentum : float
@export var grappleMomentumDecay : float = 800.0 # This uses delta, is per second
var grappleMomentumDirection : Vector2 = Vector2(0,0)
var isGrappling : bool = false
@export var whipUnlocked = true

# Attack variables
@export var attackPointOffest : float = 20.0
var attackDirection : Vector2 = Vector2(0,0)
var isAttacking : bool = false

# Whip packed scene
@export var playerWhip : PackedScene = preload("res://Player/player_whip.tscn")
@export var leafParticles : PackedScene = preload("res://Particles/leaf_effect.tscn")
@export var dashParticles : PackedScene = preload("res://Particles/dash_particles.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Child nodes
@onready var dashTimer = $DashTimer
@onready var coyoteTimer = $CoyoteTimer
@onready var attackPoint = $AttackPoint

func _physics_process(delta):

	# Starts coyote time
	if not is_on_floor():
		if(canJump and coyoteTimer.is_stopped()):
			coyoteTimer.start()
	
	# Applies gravity outside of a dash
	if not is_on_floor() and !isDashing:
		velocity.y += gravity * delta
	
	# Resets variables when you touch the ground
	elif is_on_floor():
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
	elif (velocity.x < 0):
		faceDirection = -1.0
	
	# Allows jumping when not in a dash
	if !isDashing:
		# Jump
		if Input.is_action_just_pressed("jump") and canJump:
			velocity.y = jumpVelocity
			canJump = false
		# Double Jump
		elif Input.is_action_just_pressed("jump") and canDoubleJump and doubleJumpUnlocked:
			velocity.y = jumpVelocity
			canDoubleJump = false
			var particle = leafParticles.instantiate()
			add_child(particle)
			particle.position.y += 20

		# Used for controller deadzone, horizontal input was going through when left stick was pushed up?
		if abs(inputDirection.x) > 0.35:
			# Moves character
			velocity.x = ((inputDirection.x/abs(inputDirection.x)) * moveSpeed) + (grappleMomentumDirection.x * grappleMomentum)
		else:
			# Prevents momentum, still feels a little weird when grappling
			velocity.x = 0 + (grappleMomentumDirection.x * grappleMomentum)
	
	# Reduces grappling momentum
	grappleMomentum -= grappleMomentumDecay * delta
	if(grappleMomentum <= 0):
		grappleMomentum = 0
	
	# Dash mechanic, takes precedence over all other movement
	if Input.is_action_just_pressed("dash") and canDash and dashUnlocked:
		canDash = false
		isDashing = true
		grappleMomentum = 0
		if(inputDirection != Vector2.ZERO):
			velocity = dashSpeed * inputDirection
		else:
			velocity = dashSpeed * Vector2(faceDirection,0.0)
		var particle = dashParticles.instantiate()
		add_child(particle)
		particle = leafParticles.instantiate()
		add_child(particle)
		particle.rotation_degrees = 90 + (180/PI) * atan2(inputDirection.y,inputDirection.x)
		dashTimer.start()	

	move_and_slide()

func _process(_delta):
	
	# Can only attack once at a time
	if(!isAttacking and whipUnlocked and !isDashing):
		
		# Controller and mouse attack handled differently
		# Controller using directional input
		if(Input.is_action_just_pressed("attack_controller")):
			isAttacking = true
			if(inputDirection != Vector2.ZERO):
				attackDirection = inputDirection
			else:
				attackDirection = Vector2(faceDirection,0.0)
			attackPoint.position = Vector2.ZERO + (attackDirection*attackPointOffest)
			var whip = playerWhip.instantiate()
			add_child(whip)
			whip.transform = attackPoint.transform
			whip.rotation_degrees = 90 + (180/PI) * atan2(attackPoint.position.y,attackPoint.position.x)
		
		# Mouse using mouse cursor position
		elif(Input.is_action_just_pressed("attack_mouse")):
			isAttacking = true
			attackDirection = (get_global_mouse_position()-position).normalized()
			# Switches attack direction based on where you click
			if(attackDirection.x > 0):
				faceDirection = 1
			elif(attackDirection.x < 0):
				faceDirection = -1
			attackPoint.position = Vector2.ZERO + (attackDirection*attackPointOffest)
			var whip = playerWhip.instantiate()
			add_child(whip)
			whip.transform = attackPoint.transform
			whip.rotation_degrees = 90 + (180/PI) * atan2(attackPoint.position.y,attackPoint.position.x)

# Die
func death():
	self.queue_free()

# Timer to stay dashing only for the dedicated amount of time
func _on_dash_timer_timeout():
	isDashing = false
	velocity = Vector2.ZERO

# Coyote time timer
func _on_coyote_timer_timeout():
	canJump = false
