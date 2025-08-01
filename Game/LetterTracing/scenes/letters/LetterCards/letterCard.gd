extends Panel
@export var isLastCard:bool
@onready var game_over_component: PanelContainer = $"../GameOverComponent"

func showGameOver():
	game_over_component.show()
	var childrens = game_over_component.get_children()
	for child in childrens:
		if child.is_in_group("persist"):
			child.save()


func _on_timer_timeout() -> void:
	showGameOver()
	get_tree().paused = true
