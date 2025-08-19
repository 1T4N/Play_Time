extends Button

@onready var credit_page: PanelContainer = $"../../../Credit Page"

func _on_pressed() -> void:
	credit_page.show()
