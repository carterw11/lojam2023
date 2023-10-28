extends GPUParticles2D

@onready var timer = $LifetimeTimer

func _process(_delta):
	if(!emitting):
		timer.start()


func _on_lifetime_timer_timeout():
	queue_free()
