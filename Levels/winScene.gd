extends Node2D
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.sprite.play("Idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		MusicController.stop_main()
		Transition.changeScene("res://UI/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
