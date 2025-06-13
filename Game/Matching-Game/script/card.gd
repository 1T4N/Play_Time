extends Button

var image_texture : Texture
var is_flipped = false
var is_matched = false
var flipping = false

@onready var front_image: TextureRect = $FrontImage
@onready var animation_player: AnimationPlayer = $AnimationPlayer  #reference to AnimationPlayer

func set_image(texture: Texture):
	image_texture = texture
	front_image.texture = image_texture

func flip():
	if is_matched or flipping:
		return

	flipping = true
	animation_player.play("flip_card")  #Play flip animation

	await animation_player.animation_finished
	is_flipped = not is_flipped
	front_image.visible = is_flipped
	flipping = false
