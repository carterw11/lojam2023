extends Area2D

var isGrappleAble : bool = true
@export var hasCooldown : bool = false

@onready var grappleTimer = $GrappleCooldown

func _physics_process(_delta):
	pass

func _on_grapple_cooldown_timeout():
	isGrappleAble = true

func _on_area_entered(area):
	if area.is_in_group("playerAttack") and isGrappleAble:
		isGrappleAble = false
		area.get_parent().isGrappling = true
		area.get_parent().grappleMomentum = area.get_parent().grappleVelocity
		area.get_parent().grappleMomentumDirection = (self.position - area.get_parent().position).normalized()
		area.get_parent().velocity.y = (area.get_parent().grappleMomentumDirection.y * area.get_parent().grappleMomentum)
		area.get_parent().isAttacking = false
		area.queue_free()
		if(hasCooldown):
			grappleTimer.start()
		else:
			isGrappleAble = true
