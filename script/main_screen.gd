extends Control


func _on_alphabet_pressed() -> void:
	release_focus()
	get_tree().change_scene_to_file("res://Game/LetterTracing/scenes/Compiled/Alphabet_Tracing_Game.tscn")


func _on_color_pressed() -> void:
	release_focus()
	get_tree().change_scene_to_file("res://Game/Color-Hunt/scene/color list.tscn")


func _on_matching_pressed() -> void:
	release_focus()
	get_tree().change_scene_to_file("res://Game/Matching-Game/main.tscn")


func _ready() -> void:
	print(JSON.stringify(ProfileDataGlobals.saveData, "\t"))


func _on_shape_safari_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Shape-Safari/scene/shape_safari.tscn")
	pass # Replace with function body.


func _on_sound_hunt_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Letter-Sound-Hunt/scene/letter_sound_hunt.tscn")
	pass # Replace with function body.
