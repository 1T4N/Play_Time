extends Control

@export var snap_distance: float = 48.0
@onready var ui_congrats = $CanvasLayer/CongratsLabel
@onready var targets = $Targets 
@onready var targets2 = $Targets2   # Added reference to second targets
@onready var pieces_container = $Pieces
@onready var pieces_container2 = $Pieces2   # New container for second set of pieces
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var menu_button: Button = $MarginContainer/MenuButton
@onready var menu: Control = $menu/Menu
#@onready var timer_label = $Timer/TimerLabel
#@onready var game_timer: Timer = $Timer/GameTimer
@onready var timer: Control = $menu/Timer
#@onready var click_sound: AudioStreamPlayer2D = $ClickSound

var score: int = 0
var time_left: int

# Store initial positions of shapes
var original_positions: Array = []
var original_positions2: Array = []   # For second set

func _ready():
	globalGameData.resetData()
	#change the number base on the game
	globalGameData.currentGameID = 5
	
	ui_congrats.visible = false
	update_score_label()
	randomize() # Ensure randomness

	# Save original positions of first set
	for piece in pieces_container.get_children():
		original_positions.append(piece.position)

	# Save original positions of second set
	for piece in pieces_container2.get_children():
		original_positions2.append(piece.position)

	# Hide the second set of targets and pieces at start
	targets2.visible = false
	pieces_container2.visible = false

	# Shuffle their positions
	#randomize_pieces()

## Shuffle the positions of shapes
#func randomize_pieces():
	#var shuffled_positions = original_positions.duplicate()
	#shuffled_positions.shuffle()
	#var pieces = pieces_container.get_children()
	#for i in range(pieces.size()):
		#pieces[i].position = shuffled_positions[i]

# Attempts to place a piece on its matching target
func try_place_piece(piece):
	# First check targets
	for target in targets.get_children():
		if not target.has_method("is_vacant"):
			continue
		if not target.is_vacant():
			continue

		# If IDs match and piece is close enough, snap it into place
		if target.required_id == piece.piece_id and piece.global_position.distance_to(target.global_position) <= snap_distance:
			piece.snap_to(target.global_position)
			target.occupy(piece)

			# Randomize score between 500 and 2000 each placement
			var random_points = randi_range(500, 2000)
			_add_score(random_points)

			_check_completion()
			return

	# Then check targets2 if it's visible
	if targets2.visible:
		for target in targets2.get_children():
			if not target.has_method("is_vacant"):
				continue
			if not target.is_vacant():
				continue

			# If IDs match and piece is close enough, snap it into place
			if target.required_id == piece.piece_id and piece.global_position.distance_to(target.global_position) <= snap_distance:
				piece.snap_to(target.global_position)
				target.occupy(piece)

				# Randomize score between 500 and 2000 each placement
				var random_points = randi_range(500, 2000)
				_add_score(random_points)

				_check_completion()
				return

	piece.reset_position()

func _add_score(points: int):
	score += points
	update_score_label()

func update_score_label():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

# Checks if all targets are filled
func _check_completion():
	if targets.visible:
		for target in targets.get_children():
			if target.has_method("is_vacant") and target.is_vacant():
				return  
		# If all targets are filled:
		_switch_to_targets2()
	elif targets2.visible:
		for target in targets2.get_children():
			if target.has_method("is_vacant") and target.is_vacant():
				return  
		# If all targets2 are filled:
		timer.showGameOver()
		#ui_congrats.visible = true
		#game_timer.stop()

# Switch from first targets to second targets and new pieces
func _switch_to_targets2():
	targets.visible = false
	pieces_container.visible = false
	targets2.visible = true
	pieces_container2.visible = true
	_reset_pieces2()

# Reset pieces2 to original positions
func _reset_pieces2():
	var pieces = pieces_container2.get_children()
	for i in range(pieces.size()):
		pieces[i].position = original_positions2[i]

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true

func _on_menu_exit_button_pressed() -> void:
	get_tree().paused = false
	#game_timer.start()
	#menu.visible = false
