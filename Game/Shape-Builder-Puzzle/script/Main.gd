extends Control

@export var snap_distance: float = 48.0   # how close to snap
@onready var ui_congrats = $CanvasLayer/CongratsLabel
@onready var targets = $Targets
@onready var pieces_container = $Pieces
@onready var score_label = $CanvasLayer/ScoreLabel  # Add a ScoreLabel node in CanvasLayer
@onready var menu_button: Button = $MarginContainer/MenuButton
@onready var menu: Control = $Menu

var score: int = 0

func _ready():
	ui_congrats.visible = false
	score_label.text = "Score: 0"  # Initialize label text

func try_place_piece(piece):
	# Try to place the piece into any matching vacant target within snap_distance
	for target in targets.get_children():
		if not target.has_method("is_vacant"):
			continue
		if not target.is_vacant():
			continue
		if target.required_id == piece.piece_id and piece.global_position.distance_to(target.global_position) <= snap_distance:
			piece.snap_to(target.global_position)
			target.occupy(piece)
			_add_score(1000)  # <- Increase score by 1
			_check_completion()
			return
	# no valid place found
	piece.reset_position()

func _add_score(points: int):
	score += points
	score_label.text = "Score: " + str(score)

func _check_completion():
	for target in targets.get_children():
		if target.has_method("is_vacant") and target.is_vacant():
			return  # still empty targets
	ui_congrats.visible = true


func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true


func _on_menu_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")
