extends Node2D

@export var required_id: String = ""   # must match a Piece.piece_id
var occupied_by: Node = null

func is_vacant() -> bool:
	return occupied_by == null

func occupy(piece: Node):
	occupied_by = piece

func vacate():
	occupied_by = null
