extends Control


func _on_alphabet_pressed() -> void:
	release_focus()
	#get_tree().change_scene_to_file("res://Game/LetterTracing/scenes/Compiled/Alphabet_Tracing_Game.tscn")
	globalGameData.emit_signal("transition","res://Game/LetterTracing/scenes/Compiled/Alphabet_Tracing_Game.tscn")
	MainBgm.stop()


func _on_color_pressed() -> void:
	release_focus()
	#get_tree().change_scene_to_file("res://Game/Color-Hunt/scene/color list.tscn")
	globalGameData.emit_signal("transition","res://Game/Color-Hunt/scene/color list.tscn")
	MainBgm.stop()


func _on_matching_pressed() -> void:
	release_focus()
	#get_tree().change_scene_to_file("res://Game/Matching-Game/main.tscn")
	globalGameData.emit_signal("transition","res://Game/Matching-Game/main.tscn")
	MainBgm.stop()


func _ready() -> void:
	print(JSON.stringify(ProfileDataGlobals.saveData, "\t"))
	if not MainBgm.is_playing():
		MainBgm.play()


func _on_shape_safari_pressed() -> void:
	#get_tree().change_scene_to_file("res://Game/Shape-Safari/scene/shape_safari.tscn")
	globalGameData.emit_signal("transition","res://Game/Shape-Safari/scene/shape_safari.tscn")
	MainBgm.stop()
	pass # Replace with function body.


func _on_sound_hunt_pressed() -> void:
	#get_tree().change_scene_to_file("res://Game/Letter-Sound-Hunt/scene/letter_sound_hunt.tscn")
	globalGameData.emit_signal("transition","res://Game/Letter-Sound-Hunt/scene/letter_sound_hunt.tscn")
	MainBgm.stop()
	pass # Replace with function body.


func _on_puzzle_builder_pressed() -> void:
	#get_tree().change_scene_to_file("res://Game/Shape-Builder-Puzzle/scene/Main.tscn")
	globalGameData.emit_signal("transition","res://Game/Shape-Builder-Puzzle/scene/Main.tscn")
	MainBgm.stop()
