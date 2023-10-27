extends CanvasLayer

@onready var transition = $AnimatedSprite2D

func changeScene (target: String) -> void:
	transition.play()
	await transition.animation_finished
	get_tree().change_scene_to_file(target)
	transition.play_backwards()
	
