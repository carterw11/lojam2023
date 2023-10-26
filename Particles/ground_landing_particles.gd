extends GPUParticles2D

func _ready():
	self.emitting = true
	
func _process(_delta):
	if(!self.emitting):
		queue_free()
 
