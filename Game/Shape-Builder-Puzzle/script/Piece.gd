extends Area2D

@export var piece_id: String = ""    # set per-piece in Inspector

var dragging := false
var offset := Vector2.ZERO
var original_position := Vector2.ZERO
var placed := false

func _ready():
	original_position = global_position
	if not has_node("CollisionShape2D"):
		push_error("Piece.tscn missing CollisionShape2D")
	elif $CollisionShape2D.shape == null:
		push_error("Piece.tscn CollisionShape2D.shape not assigned")

func _input(event):
	if placed:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_point = to_local(get_global_mouse_position())
			if $CollisionShape2D.shape and _point_inside_collision(local_point):
				dragging = true
				offset = global_position - get_global_mouse_position()
		else:
			if dragging:
				dragging = false
				var main = get_tree().current_scene
				if main and main.has_method("try_place_piece"):
					main.try_place_piece(self)
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset

func _point_inside_collision(local_point: Vector2) -> bool:
	var shape = $CollisionShape2D.shape
	if shape == null:
		return false
	if shape is CircleShape2D:
		return local_point.length() <= shape.radius
	elif shape is RectangleShape2D:
		var ext = shape.extents
		return Rect2(-ext, ext * 2).has_point(local_point)
	return false

func snap_to(pos: Vector2):
	global_position = pos
	placed = true

func reset_position():
	global_position = original_position
