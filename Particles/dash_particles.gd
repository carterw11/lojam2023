extends Node2D

@onready var trailParticles = $TrailEffect

func _ready():
	trailParticles.emitting = true

func _process(_delta):
	if(get_child_count() == 0):
		queue_free()
