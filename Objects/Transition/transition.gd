extends CanvasLayer

@onready var transition = $AnimatedSprite2D

func changeScene (next: String) -> void:
	transition.visible = true
	transition.play_backwards("transitionNext")
	await transition.animation_finished
	get_tree().change_scene_to_file(next)
	transition.play("transitionNext")
	await transition.animation_finished
	transition.visible = false
	
	
	
