extends Control
@onready var margin_container: MarginContainer = $MarginContainer


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		margin_container.visible = true
		get_tree().paused = true

func _on_resume_pressed() -> void:
	margin_container.visible = false
	get_tree().paused = false


func _on_back_pressed() -> void:
	pass # Replace with function body.
