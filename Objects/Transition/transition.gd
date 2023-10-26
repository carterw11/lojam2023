extends Sprite2D

@onready var animationPlayer = $AnimationPlayer
@export var animation = "Slide"

# Called when the node enters the scene tree for the first time.
func _ready():
	var img = get_viewport().get_texture().get_data()
	img.flip_v()
	var screenshot = ImageTexture.new()
	screenshot.create_from_image(img)
	texture = screenshot
	animationPlayer.play(animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
