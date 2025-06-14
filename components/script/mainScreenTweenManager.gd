extends Node
@export var delayScaleAnimation:float = 0.2
@onready var featured: HBoxContainer = $"../featured"
@onready var games_container_1: HBoxContainer = $"../gamesContainer1"

func _ready() -> void:
	for child in featured.get_children():
		child.scaleUpAnimation()
		await get_tree().create_timer(delayScaleAnimation).timeout
		child.isFinishedInitializing = true
	
	for child in games_container_1.get_children():
		child.scaleUpAnimation()
		await get_tree().create_timer(delayScaleAnimation).timeout
		child.isFinishedInitializing = true
	
