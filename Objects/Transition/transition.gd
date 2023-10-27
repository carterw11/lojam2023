extends CanvasLayer

@onready var transition = $AnimationPlayer

func changeScene (target: String) -> void:
	transition.play("disolve")
	await transition.animation_finished
	get_tree().change_scene_to_file(target)
	transition.play_backwards("disolve")
	
