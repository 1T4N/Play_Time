extends TextureRect
func _ready() -> void:
	var iconTexture
	if ProfileDataGlobals.saveData.profile.has("iconPath"):
		iconTexture = load(ProfileDataGlobals.saveData.profile.iconPath)
	else:
		iconTexture = load("res://GameUI/assets/profileIcons/fixed/compressed_bunny.png")
	set_texture(iconTexture)
