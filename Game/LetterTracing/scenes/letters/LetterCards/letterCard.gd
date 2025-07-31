extends Panel
@export var isLastCard:bool
@onready var game_over_component: PanelContainer = $"../GameOverComponent"

func showGameOver():
	game_over_component.show()
