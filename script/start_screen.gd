extends Control
@onready var touch_the_screen: Button = $"Panel/touch the screen"

func _on_touch_the_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")
 
