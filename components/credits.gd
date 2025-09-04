extends Button

@onready var credit_page: PanelContainer = $"../../../CREDIT PAGE"

func _on_pressed() -> void:
	credit_page.show()
