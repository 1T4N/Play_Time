extends Control
@onready var margin_container: MarginContainer = $Panel/MarginContainer1


func _on_alphabet_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/LetterTracing/scenes/Compiled/Alphabet_Tracing_Game.tscn")


func _on_color_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Color-Hunt/scene/color list.tscn")


func _on_matching_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Matching-Game/main.tscn")
