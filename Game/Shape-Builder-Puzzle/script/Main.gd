extends Node2D

@export var snap_distance: float = 48.0   # how close to snap
@onready var ui_congrats = $CanvasLayer/CongratsLabel
@onready var targets = $Targets
@onready var pieces_container = $Pieces

func _ready():
	ui_congrats.visible = false

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
			_check_completion()
			return
	# no valid place found
	piece.reset_position()

func _check_completion():
	for target in targets.get_children():
		if target.has_method("is_vacant") and target.is_vacant():
			return  # still empty targets
	ui_congrats.visible = true
