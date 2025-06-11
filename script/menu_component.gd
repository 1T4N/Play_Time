extends Node

@onready var margin_container: MarginContainer = $MarginContainer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if self.visible == true:
			self.visible = false
			get_tree().paused = false
			pass
		else:
			get_tree().paused = true
			self.visible = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.visible = false

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn") #you can change the scene here if you pressed "Back_Button"
