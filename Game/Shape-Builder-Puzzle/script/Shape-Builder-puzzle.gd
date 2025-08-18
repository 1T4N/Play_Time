extends Control
@export var snap_distance: float = 48.0   # How close a piece must be to a target to snap into place
@onready var ui_congrats = $CanvasLayer/CongratsLabel
@onready var targets = $Targets 
@onready var pieces_container = $Pieces
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var menu_button: Button = $MarginContainer/MenuButton
@onready var menu: Control = $Menu
@onready var timer_label = $Timer/TimerLabel
@onready var game_timer = $Timer/GameTimer


var score: int = 0                                      
var time_left: int = 60							# Time remaining in seconds

# Points for each shape type
var shape_points = {
	"Square": 500,
	"Triangle": 1000,
	"Circle": 1500
}

# Called when the scene is ready
func _ready():
	ui_congrats.visible = false           # Hide congratulations message at start
	update_score_label()                  # Show starting score

	# Initialize and start timer instantly
	time_left = 60
	timer_label.text = "Timer: " + str(time_left)
	game_timer.wait_time = 1.0
	game_timer.one_shot = false
	game_timer.start()

# Attempts to place a piece on its matching target
func try_place_piece(piece):
	for target in targets.get_children():
		if not target.has_method("is_vacant"):
			continue
		# Skip if target is already occupied
		if not target.is_vacant():
			continue
		# If IDs match and piece is close enough, snap it into place
		if target.required_id == piece.piece_id and piece.global_position.distance_to(target.global_position) <= snap_distance:
			piece.snap_to(target.global_position)
			target.occupy(piece)
			_add_score(piece.points)
			_check_completion()
			return
	# If no valid target found, reset piece to original position
	piece.reset_position()

# Adds points to the player's score
func _add_score(points: int):
	score += points
	update_score_label()

func update_score_label():
	score_label.text = "Score: " + str(score)

# Checks if all targets are filled
func _check_completion():
	for target in targets.get_children():
		if target.has_method("is_vacant") and target.is_vacant():
			return  # If any target is still empty, game is not complete

	ui_congrats.visible = true
	game_timer.stop()


func _on_menu_button_pressed() -> void:
	get_tree().paused = true   
	game_timer.stop()         
	menu.visible = true       


func _on_menu_exit_button_pressed() -> void:
	get_tree().paused = false  
	game_timer.start()         
	menu.visible = false       


func _on_time_up():
	ui_congrats.visible = true
	ui_congrats.text = "Time's Up!"  


func _on_game_timer_timeout() -> void:
	time_left -= 1                                      
	timer_label.text = "Timer: " + str(time_left)      

	if time_left <= 0:                                 
		game_timer.stop()                               
		_on_time_up()                                   
