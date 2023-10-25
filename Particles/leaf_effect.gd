extends GPUParticles2D

func _ready():
	self.emitting = true

func _process(delta):
	if(!emitting):
		queue_free()
