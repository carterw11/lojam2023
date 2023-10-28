extends Node2D

@onready var trailParticles = $TrailEffect
@onready var flippedTrailParticles = $TrailEffectFlipped

func _process(_delta):
	if(get_child_count() == 0):
		queue_free()
