extends Button

var image_texture : Texture
var is_flipped = false
var is_matched = false

@onready var front_image: TextureRect = $FrontImage

func set_image(texture: Texture):
	image_texture = texture
	front_image.texture = image_texture

func flip():
	if is_matched:
		return
	is_flipped = not is_flipped
	front_image.visible = is_flipped
